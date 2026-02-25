import Foundation

@MainActor
final class RecipeComposerViewModel: ObservableObject {
    @Published var draft: RecipeDraft = RecipeDraft()
    @Published private(set) var isSubmitting = false
    @Published var message: String?

    var canPublish: Bool {
        draft.canPublish && !isSubmitting
    }

    func addStep() {
        draft.steps.append(RecipeDraftStep())
    }

    func removeStep(id: UUID) {
        guard draft.steps.count > 1 else {
            return
        }
        draft.steps.removeAll(where: { $0.id == id })
    }

    func moveStep(from source: IndexSet, to destination: Int) {
        draft.steps.move(fromOffsets: source, toOffset: destination)
    }

    func validationSummary() -> String {
        draft.validationErrors.joined(separator: "\n")
    }

    func publish(
        using repository: RecipeRepository,
        authorName: String,
        userId: String
    ) async -> RecipeItem? {
        guard draft.canPublish else {
            message = draft.validationErrors.first
            return nil
        }

        isSubmitting = true
        defer { isSubmitting = false }

        guard let created = repository.createRecipe(from: draft, authorName: authorName, userId: userId) else {
            message = L10n.text("compose.publish.failed", default: "Failed to publish.")
            return nil
        }

        message = L10n.text("compose.publish.success", default: "Recipe published.")
        draft = RecipeDraft()
        return created
    }
}
