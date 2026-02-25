import SwiftUI

struct BrewTimerView: View {
    let recipe: RecipeItem

    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: BrewTimerViewModel

    init(recipe: RecipeItem) {
        self.recipe = recipe
        _viewModel = StateObject(wrappedValue: BrewTimerViewModel(recipe: recipe))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                header
                timerHero
                chips
                animationArea
                controls
                stepNav
                stopButton
            }
            .padding(.horizontal, 14)
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
        .background(Color(hex: "FFFFFF"))
        .onChange(of: scenePhase) { _, newPhase in
            viewModel.handleScenePhaseChange(newPhase)
        }
        .onDisappear {
            viewModel.stopAndReset()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(L10n.text("brew.timer.title", default: "Brew Timer"))
                    .font(.app(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F1A16"))
                Spacer()
                Button {
                    viewModel.stopAndReset()
                    dismiss()
                } label: {
                    PenIcon(kind: .add, size: 16, color: Color(hex: "8B5E3C"))
                        .rotationEffect(.degrees(45))
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 30)

            Text(L10n.text("brew.timer.subtitle", default: "Brew in progress · Keep extraction smooth"))
                .font(.app(size: 11))
                .foregroundColor(Color(hex: "6A625B"))
        }
    }

    private var timerHero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.remainingText)
                .font(.app(size: 56))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "2F2721"))

            Text(stepHeadline)
                .font(.app(size: 20))
                .fontWeight(.heavy)
                .foregroundColor(Color(hex: "7C4A2D"))
        }
    }

    private var chips: some View {
        HStack(spacing: 8) {
            ForEach(recipe.steps) { step in
                Button {
                    viewModel.selectStep(stepID: step.id)
                } label: {
                    BrewStepChip(
                        label: "\(step.stepOrder) \(shortLabel(step.description))",
                        selected: step.id == viewModel.currentStep?.id
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 44)
    }

    private var animationArea: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(hex: "FCF9F5"))
            .overlay(
                VStack(spacing: 4) {
                    Text(L10n.text("brew.timer.animation.title", default: "BLOOM Animation Area"))
                        .font(.app(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "111827"))

                    Text(animationSubtitle)
                        .font(.app(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "4B5563"))
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "E7DED4"), lineWidth: 1)
            )
            .frame(height: 280)
    }

    private var controls: some View {
        HStack(spacing: 10) {
            BrewControlButton(text: L10n.text("brew.timer.minus10", default: "-10s"))
                .onTapGesture {
                    viewModel.adjustCurrentStep(seconds: -10)
                }

            BrewControlButton(text: primaryButtonTitle)
                .onTapGesture {
                    togglePrimary()
                }

            BrewControlButton(text: L10n.text("brew.timer.plus10", default: "+10s"))
                .onTapGesture {
                    viewModel.adjustCurrentStep(seconds: 10)
                }
        }
        .frame(height: 40)
    }

    private var stepNav: some View {
        HStack(spacing: 8) {
            BrewSecondaryAction(text: L10n.text("brew.timer.prev", default: "Prev Step"))
                .onTapGesture {
                    viewModel.moveToPreviousStep()
                }

            BrewSecondaryAction(text: L10n.text("brew.timer.next", default: "Next Step"))
                .onTapGesture {
                    viewModel.moveToNextStep()
                }
        }
        .frame(height: 36)
    }

    private var stopButton: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(hex: "C44A3A"))
            .frame(height: 42)
            .overlay(
                Text(L10n.text("brew.timer.stop", default: "Stop Brew"))
                    .font(.app(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            )
            .onTapGesture {
                viewModel.stopAndReset()
                dismiss()
            }
    }

    private var stepHeadline: String {
        guard let step = viewModel.currentStep else {
            return L10n.text("timer.step.complete", default: "COMPLETED")
        }
        return "CURRENT STEP \(step.stepOrder) · \(shortLabel(step.description))"
    }

    private var animationSubtitle: String {
        let current = shortLabel(viewModel.currentStep?.description ?? "DONE")
        let next = shortLabel(viewModel.nextStep?.description ?? "NONE")
        return "Now: \(current)  ·  Next: \(next)"
    }

    private var primaryButtonTitle: String {
        switch viewModel.state {
        case .idle, .completed:
            return L10n.text("timer.start", default: "Start")
        case .running:
            return L10n.text("brew.timer.pause", default: "Pause")
        case .paused:
            return L10n.text("timer.resume", default: "Resume")
        }
    }

    private func togglePrimary() {
        switch viewModel.state {
        case .idle, .completed:
            viewModel.start()
        case .running, .paused:
            viewModel.togglePause()
        }
    }

    private func shortLabel(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "STEP" }
        let words = trimmed.split(separator: " ")
        if words.count == 1 {
            return words[0].uppercased()
        }
        return Array(words.prefix(2)).joined(separator: " ").uppercased()
    }
}

struct BrewTimerView_Previews: PreviewProvider {
    static var previews: some View {
        BrewTimerView(recipe: RecipeRepository().recipes.first!)
    }
}
