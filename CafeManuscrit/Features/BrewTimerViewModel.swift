import AudioToolbox
import Foundation
import SwiftUI
import UIKit
import UserNotifications

@MainActor
final class BrewTimerViewModel: ObservableObject {
    let recipe: RecipeItem

    @Published private(set) var state: BrewTimerState = .idle
    @Published private(set) var currentStepIndex: Int = 0
    @Published private(set) var remainingInCurrentStep: Int
    @Published private(set) var elapsedSec: Int = 0

    private var timer: Timer?
    private let notificationPrefix: String

    init(recipe: RecipeItem) {
        self.recipe = recipe
        self.remainingInCurrentStep = recipe.steps.first?.durationSec ?? 0
        self.notificationPrefix = "brew-step-\(recipe.id)"
    }

    var currentStep: RecipeStepItem? {
        guard currentStepIndex < recipe.steps.count else {
            return nil
        }
        return recipe.steps[currentStepIndex]
    }

    var nextStep: RecipeStepItem? {
        let next = currentStepIndex + 1
        guard next < recipe.steps.count else {
            return nil
        }
        return recipe.steps[next]
    }

    var totalDurationSec: Int {
        recipe.steps.reduce(0) { $0 + $1.durationSec }
    }

    var progress: Double {
        guard totalDurationSec > 0 else {
            return 0
        }
        return min(1, Double(elapsedSec) / Double(totalDurationSec))
    }

    var remainingText: String {
        let min = remainingInCurrentStep / 60
        let sec = remainingInCurrentStep % 60
        return String(format: "%02d:%02d", min, sec)
    }

    var stepProgressText: String {
        "\(min(currentStepIndex + 1, recipe.steps.count))/\(recipe.steps.count)"
    }

    func start() {
        guard !recipe.steps.isEmpty else {
            return
        }

        if state == .idle || state == .completed {
            resetCounters()
        }

        state = .running
        applyIdleTimer(isDisabled: true)
        runTimer()
    }

    func pause() {
        guard state == .running else {
            return
        }
        state = .paused
        stopTimer()
        cancelStepNotifications()
        restoreIdleTimer()
    }

    func resume() {
        guard state == .paused else {
            return
        }
        state = .running
        applyIdleTimer(isDisabled: true)
        runTimer()
    }

    func togglePause() {
        if state == .running {
            pause()
        } else if state == .paused {
            resume()
        }
    }

    func restartFromBeginning() {
        stopTimer()
        cancelStepNotifications()
        resetCounters()
        state = .idle
        restoreIdleTimer()
    }

    func stopAndReset() {
        stopTimer()
        cancelStepNotifications()
        resetCounters()
        state = .idle
        restoreIdleTimer()
    }

    func adjustCurrentStep(seconds: Int) {
        guard state == .running || state == .paused else {
            return
        }

        let base = currentStep?.durationSec ?? 0
        let adjusted = max(1, remainingInCurrentStep + seconds)
        remainingInCurrentStep = adjusted

        // Keep elapsed time coherent with the modified remaining duration.
        let consumedOnCurrentStep = max(0, base - adjusted)
        let consumedBeforeCurrentStep = recipe.steps.prefix(currentStepIndex).reduce(0) { $0 + $1.durationSec }
        elapsedSec = consumedBeforeCurrentStep + consumedOnCurrentStep
    }

    func moveToNextStep() {
        guard !recipe.steps.isEmpty else {
            return
        }
        if currentStepIndex + 1 >= recipe.steps.count {
            finishTimer()
            return
        }

        currentStepIndex += 1
        remainingInCurrentStep = recipe.steps[currentStepIndex].durationSec
        elapsedSec = recipe.steps.prefix(currentStepIndex).reduce(0) { $0 + $1.durationSec }
        triggerStepFeedback()
    }

    func moveToPreviousStep() {
        guard currentStepIndex > 0 else {
            return
        }

        currentStepIndex -= 1
        remainingInCurrentStep = recipe.steps[currentStepIndex].durationSec
        elapsedSec = recipe.steps.prefix(currentStepIndex).reduce(0) { $0 + $1.durationSec }
    }

    func selectStep(stepID: UUID) {
        guard let targetIndex = recipe.steps.firstIndex(where: { $0.id == stepID }) else {
            return
        }

        stopTimer()
        cancelStepNotifications()

        currentStepIndex = targetIndex
        let duration = recipe.steps[targetIndex].durationSec
        let midRemaining = max(1, duration / 2)
        remainingInCurrentStep = midRemaining

        let consumedBefore = recipe.steps.prefix(targetIndex).reduce(0) { $0 + $1.durationSec }
        let consumedInStep = duration - midRemaining
        elapsedSec = min(totalDurationSec, consumedBefore + consumedInStep)

        state = .paused
        restoreIdleTimer()
    }

    func handleScenePhaseChange(_ phase: ScenePhase) {
        guard state == .running else {
            return
        }

        switch phase {
        case .background:
            scheduleStepNotifications()
        case .active:
            cancelStepNotifications()
        default:
            break
        }
    }

    private func runTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.tick()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard state == .running else {
            return
        }

        guard !recipe.steps.isEmpty else {
            finishTimer()
            return
        }

        remainingInCurrentStep -= 1
        elapsedSec = min(totalDurationSec, elapsedSec + 1)

        if remainingInCurrentStep <= 0 {
            if currentStepIndex + 1 < recipe.steps.count {
                currentStepIndex += 1
                remainingInCurrentStep = recipe.steps[currentStepIndex].durationSec
                triggerStepFeedback()
            } else {
                finishTimer()
            }
        }
    }

    private func finishTimer() {
        stopTimer()
        cancelStepNotifications()
        state = .completed
        remainingInCurrentStep = 0
        elapsedSec = totalDurationSec
        restoreIdleTimer()
    }

    private func resetCounters() {
        currentStepIndex = 0
        remainingInCurrentStep = recipe.steps.first?.durationSec ?? 0
        elapsedSec = 0
    }

    private func triggerStepFeedback() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        AudioServicesPlaySystemSound(1104)
    }

    private func applyIdleTimer(isDisabled: Bool) {
        UIApplication.shared.isIdleTimerDisabled = isDisabled
    }

    private func restoreIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = false
    }

    private func scheduleStepNotifications() {
        Task {
            let center = UNUserNotificationCenter.current()
            let granted = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
            guard granted else {
                return
            }

            cancelStepNotifications()

            var cumulativeSeconds = max(1, remainingInCurrentStep)
            for stepIndex in (currentStepIndex + 1)..<recipe.steps.count {
                let step = recipe.steps[stepIndex]

                let content = UNMutableNotificationContent()
                content.title = L10n.text("timer.notification.step.title", default: "다음 단계")
                content.body = "\(step.stepOrder). \(step.description)"
                content.sound = .default

                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: TimeInterval(cumulativeSeconds),
                    repeats: false
                )
                let request = UNNotificationRequest(
                    identifier: "\(notificationPrefix)-\(stepIndex)",
                    content: content,
                    trigger: trigger
                )
                try? await center.add(request)

                cumulativeSeconds += step.durationSec
            }

            let completed = UNMutableNotificationContent()
            completed.title = L10n.text("timer.notification.complete.title", default: "브루 완료")
            completed.body = L10n.text("timer.notification.complete.body", default: "모든 단계를 완료했습니다.")
            completed.sound = .default

            let completedTrigger = UNTimeIntervalNotificationTrigger(
                timeInterval: TimeInterval(max(1, cumulativeSeconds)),
                repeats: false
            )
            let completedRequest = UNNotificationRequest(
                identifier: "\(notificationPrefix)-completed",
                content: completed,
                trigger: completedTrigger
            )
            try? await center.add(completedRequest)
        }
    }

    private func cancelStepNotifications() {
        let center = UNUserNotificationCenter.current()
        let ids = (0...recipe.steps.count).map { "\(notificationPrefix)-\($0)" } + ["\(notificationPrefix)-completed"]
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
}
