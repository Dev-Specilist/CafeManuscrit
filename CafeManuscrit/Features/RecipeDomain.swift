import Foundation

enum FeedSortOption: String, CaseIterable, Identifiable {
    case latest
    case popular

    var id: String { rawValue }

    var title: String {
        switch self {
        case .latest:
            return L10n.text("feed.sort.latest", default: "최신순")
        case .popular:
            return L10n.text("feed.sort.popular", default: "인기순")
        }
    }

    var apiValue: String {
        switch self {
        case .latest:
            return "latest"
        case .popular:
            return "popular"
        }
    }
}

enum GrindSize: String, CaseIterable, Codable, Identifiable {
    case fine
    case mediumFine
    case medium
    case mediumCoarse
    case coarse

    var id: String { rawValue }

    var title: String {
        switch self {
        case .fine:
            return "Fine"
        case .mediumFine:
            return "Medium-Fine"
        case .medium:
            return "Medium"
        case .mediumCoarse:
            return "Medium-Coarse"
        case .coarse:
            return "Coarse"
        }
    }

    var apiValue: String {
        switch self {
        case .fine:
            return "fine"
        case .mediumFine:
            return "medium_fine"
        case .medium:
            return "medium"
        case .mediumCoarse:
            return "medium_coarse"
        case .coarse:
            return "coarse"
        }
    }
}

struct RecipeFilter: Equatable {
    var brewMethod: BrewMethod?
    var roastLevel: RoastLevel?
    var grindSize: GrindSize?

    static let none = RecipeFilter()

    var hasValue: Bool {
        brewMethod != nil || roastLevel != nil || grindSize != nil
    }

    var apiParameters: [String: String] {
        var result: [String: String] = [:]
        if let brewMethod {
            result["brewMethod"] = brewMethod.apiValue
        }
        if let roastLevel {
            result["roastLevel"] = roastLevel.apiValue
        }
        if let grindSize {
            result["grindSize"] = grindSize.apiValue
        }
        return result
    }
}

extension BrewMethod {
    var apiValue: String {
        switch self {
        case .v60:
            return "v60"
        case .chemex:
            return "chemex"
        case .aeropress:
            return "aeropress"
        case .frenchPress:
            return "french_press"
        case .pourOver:
            return "pour_over"
        case .kalita:
            return "kalita"
        }
    }
}

extension RoastLevel {
    var apiValue: String {
        switch self {
        case .light, .mediumLight:
            return "light"
        case .medium:
            return "medium"
        case .mediumDark, .dark:
            return "dark"
        }
    }
}

struct RecipeStepItem: Identifiable, Codable, Equatable {
    let id: UUID
    var stepOrder: Int
    var description: String
    var durationSec: Int
    var waterAmountMl: Double?

    init(
        id: UUID = UUID(),
        stepOrder: Int,
        description: String,
        durationSec: Int,
        waterAmountMl: Double?
    ) {
        self.id = id
        self.stepOrder = stepOrder
        self.description = description
        self.durationSec = durationSec
        self.waterAmountMl = waterAmountMl
    }
}

struct RecipeItem: Identifiable, Equatable {
    let id: String
    var title: String
    var summary: String
    var authorName: String
    var beanName: String
    var beanOrigin: String
    var roastLevel: RoastLevel
    var processMethod: String
    var brewMethod: BrewMethod
    var grindSize: GrindSize
    var grinderName: String
    var grinderSetting: String
    var waterTemperature: Int
    var coffeeAmountG: Double
    var waterAmountMl: Double
    var totalBrewTimeSec: Int
    var steps: [RecipeStepItem]
    var tags: [String]
    var imageURL: String?
    var likeCount: Int
    var bookmarkCount: Int
    var isLiked: Bool
    var isBookmarked: Bool
    var createdAt: Date

    var totalTimeText: String {
        let min = totalBrewTimeSec / 60
        let sec = totalBrewTimeSec % 60
        return String(format: "%02d:%02d", min, sec)
    }

    var coffeeRatioText: String {
        guard coffeeAmountG > 0 else { return "-" }
        let ratio = waterAmountMl / coffeeAmountG
        return String(format: "1:%.1f", ratio)
    }

    var cardMetaLine: String {
        "\(beanName) · \(brewMethod.displayName) · \(totalTimeText)"
    }
}

struct RecipePage {
    var items: [RecipeItem]
    var nextCursor: String?
}

struct RecipeDraftStep: Identifiable, Equatable {
    let id: UUID
    var description: String
    var durationSec: String
    var waterAmountMl: String

    init(
        id: UUID = UUID(),
        description: String = "",
        durationSec: String = "",
        waterAmountMl: String = ""
    ) {
        self.id = id
        self.description = description
        self.durationSec = durationSec
        self.waterAmountMl = waterAmountMl
    }

    var isValid: Bool {
        guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        guard let duration = Int(durationSec), duration > 0 else {
            return false
        }
        return true
    }

    func toRecipeStep(order: Int) -> RecipeStepItem? {
        guard let duration = Int(durationSec), duration > 0 else {
            return nil
        }

        let water = Double(waterAmountMl)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedDescription.isEmpty else {
            return nil
        }

        return RecipeStepItem(
            stepOrder: order,
            description: trimmedDescription,
            durationSec: duration,
            waterAmountMl: water
        )
    }
}

struct RecipeDraft: Equatable {
    var title: String = ""
    var description: String = ""
    var beanName: String = ""
    var beanOrigin: String = ""
    var roastLevel: RoastLevel?
    var processMethod: String = ""
    var brewMethod: BrewMethod?
    var grindSize: GrindSize?
    var grinderName: String = ""
    var grinderSetting: String = ""
    var waterTemperature: String = ""
    var coffeeAmountG: String = ""
    var waterAmountMl: String = ""
    var tagsInput: String = ""
    var steps: [RecipeDraftStep] = [RecipeDraftStep()]

    var tags: [String] {
        tagsInput
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var canPublish: Bool {
        validationErrors.isEmpty
    }

    var validationErrors: [String] {
        var errors: [String] = []
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append(L10n.text("compose.validation.title", default: "Title is required."))
        }
        if beanName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append(L10n.text("compose.validation.bean", default: "Bean name is required."))
        }
        if brewMethod == nil {
            errors.append(L10n.text("compose.validation.method", default: "Select a brew method."))
        }
        if steps.isEmpty {
            errors.append(L10n.text("compose.validation.steps.empty", default: "Add at least one step."))
        } else if steps.contains(where: { !$0.isValid }) {
            errors.append(L10n.text("compose.validation.steps.invalid", default: "Each step needs a description and duration."))
        }
        return errors
    }

    func toRecipe(authorName: String, userId: String, createdAt: Date = .now) -> RecipeItem? {
        guard canPublish else { return nil }
        guard let brewMethod else { return nil }

        let mappedSteps = steps.enumerated().compactMap { index, step in
            step.toRecipeStep(order: index + 1)
        }

        guard !mappedSteps.isEmpty else { return nil }

        let total = mappedSteps.reduce(0) { $0 + $1.durationSec }

        return RecipeItem(
            id: "draft_\(userId)_\(UUID().uuidString)",
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            summary: description.trimmingCharacters(in: .whitespacesAndNewlines),
            authorName: authorName,
            beanName: beanName.trimmingCharacters(in: .whitespacesAndNewlines),
            beanOrigin: beanOrigin.trimmingCharacters(in: .whitespacesAndNewlines),
            roastLevel: roastLevel ?? .medium,
            processMethod: processMethod.trimmingCharacters(in: .whitespacesAndNewlines),
            brewMethod: brewMethod,
            grindSize: grindSize ?? .medium,
            grinderName: grinderName.trimmingCharacters(in: .whitespacesAndNewlines),
            grinderSetting: grinderSetting.trimmingCharacters(in: .whitespacesAndNewlines),
            waterTemperature: Int(waterTemperature) ?? 92,
            coffeeAmountG: Double(coffeeAmountG) ?? 15,
            waterAmountMl: Double(waterAmountMl) ?? 240,
            totalBrewTimeSec: total,
            steps: mappedSteps,
            tags: tags,
            imageURL: nil,
            likeCount: 0,
            bookmarkCount: 0,
            isLiked: false,
            isBookmarked: false,
            createdAt: createdAt
        )
    }
}

enum BrewTimerState: String {
    case idle
    case running
    case paused
    case completed
}
