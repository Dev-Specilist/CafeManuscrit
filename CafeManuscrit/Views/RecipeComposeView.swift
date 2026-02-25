import SwiftUI

struct RecipeComposeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var repository: RecipeRepository
    @StateObject private var viewModel = RecipeComposerViewModel()

    @State private var showValidationAlert = false
    @State private var showPreview = false
    @State private var showTimerTest = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    basicSection
                    stepsSection
                    actions
                }
                .padding(.horizontal, 14)
                .padding(.top, 12)
                .padding(.bottom, 16)
            }
            .navigationTitle(L10n.text("compose.title", default: "Create Recipe"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.text("common.close", default: "Close")) {
                        dismiss()
                    }
                }
            }
            .alert(
                L10n.text("compose.validation.alert", default: "Please check your inputs."),
                isPresented: $showValidationAlert
            ) {
                Button(L10n.text("common.ok", default: "OK"), role: .cancel) {}
            } message: {
                Text(viewModel.validationSummary())
            }
            .sheet(isPresented: $showPreview) {
                if let recipe = previewRecipe {
                    RecipeDraftPreviewSheet(recipe: recipe)
                }
            }
            .fullScreenCover(isPresented: $showTimerTest) {
                if let recipe = previewRecipe {
                    BrewTimerView(recipe: recipe)
                }
            }
        }
    }

    private var basicSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.text("compose.basic", default: "Basic Info"))
                .font(.app(size: 16))
                .fontWeight(.semibold)

            inputField(L10n.text("compose.field.title", default: "Title (required)"), text: $viewModel.draft.title)
            inputField(L10n.text("compose.field.bean", default: "Bean name (required)"), text: $viewModel.draft.beanName)
            inputField(L10n.text("compose.field.summary", default: "Summary"), text: $viewModel.draft.description)

            HStack(spacing: 8) {
                pickerField(
                    title: L10n.text("compose.field.method", default: "Brew Method"),
                    selection: $viewModel.draft.brewMethod,
                    values: BrewMethod.allCases,
                    label: { $0.displayName }
                )

                inputField(L10n.text("compose.field.water_temp", default: "Water Temp (°C)"), text: $viewModel.draft.waterTemperature)
            }
        }
        .padding(12)
        .background(Color(hex: "FCFAF8"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E8E1DA"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(L10n.text("compose.steps", default: "Brew Steps"))
                    .font(.app(size: 16))
                    .fontWeight(.semibold)

                Spacer(minLength: 0)

                Button {
                    viewModel.addStep()
                } label: {
                    HStack(spacing: 4) {
                        PenIcon(kind: .add, size: 14, color: Color(hex: "8B5E3C"))
                        Text(L10n.text("compose.steps.add", default: "Add Step"))
                            .font(.app(size: 12))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "8B5E3C"))
                    }
                }
                .buttonStyle(.plain)
            }

            ForEach(Array(viewModel.draft.steps.enumerated()), id: \.element.id) { index, step in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Step \(index + 1)")
                            .font(.app(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "7C4A2D"))

                        Spacer(minLength: 0)

                        if viewModel.draft.steps.count > 1 {
                            Button(role: .destructive) {
                                viewModel.removeStep(id: step.id)
                            } label: {
                                Text(L10n.text("compose.steps.delete", default: "Delete"))
                                    .font(.app(size: 11))
                            }
                        }
                    }

                    inputField(L10n.text("compose.steps.desc", default: "Step description (required)"), text: bindingForStep(step.id).description)

                    HStack(spacing: 8) {
                        inputField(L10n.text("compose.steps.duration", default: "Duration (sec)"), text: bindingForStep(step.id).durationSec)
                        inputField(L10n.text("compose.steps.water", default: "Water (ml)"), text: bindingForStep(step.id).waterAmountMl)
                    }
                }
                .padding(10)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "E7E2DC"), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(12)
        .background(Color(hex: "FCFAF8"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E8E1DA"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var actions: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Button {
                    if previewRecipe == nil {
                        showValidationAlert = true
                    } else {
                        showPreview = true
                    }
                } label: {
                    actionButton(title: L10n.text("compose.action.preview", default: "Preview"), primary: false)
                }

                Button {
                    if previewRecipe == nil {
                        showValidationAlert = true
                    } else {
                        showTimerTest = true
                    }
                } label: {
                    actionButton(title: L10n.text("compose.action.timer_test", default: "Timer Test"), primary: false)
                }
            }

            Button {
                Task {
                    let authorName = appViewModel.currentUser?.name ?? "Me"
                    let userId = appViewModel.currentUser?.id ?? "me"
                    if await viewModel.publish(using: repository, authorName: authorName, userId: userId) != nil {
                        dismiss()
                    }
                }
            } label: {
                actionButton(
                    title: viewModel.isSubmitting
                        ? L10n.text("compose.action.publishing", default: "Publishing...")
                        : L10n.text("compose.action.publish", default: "Publish"),
                    primary: true
                )
            }
            .disabled(!viewModel.canPublish)
            .opacity(viewModel.canPublish ? 1 : 0.5)

            if let message = viewModel.message {
                Text(message)
                    .font(.app(size: 12))
                    .foregroundColor(Color(hex: "6A625B"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var previewRecipe: RecipeItem? {
        let authorName = appViewModel.currentUser?.name ?? "Me"
        let userId = appViewModel.currentUser?.id ?? "me"
        return viewModel.draft.toRecipe(authorName: authorName, userId: userId)
    }

    private func bindingForStep(_ stepID: UUID) -> Binding<RecipeDraftStep> {
        guard let index = viewModel.draft.steps.firstIndex(where: { $0.id == stepID }) else {
            return .constant(RecipeDraftStep())
        }
        return $viewModel.draft.steps[index]
    }

    private func inputField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .font(.app(size: 13))
            .padding(.horizontal, 10)
            .frame(height: 38)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "E7E2DC"), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func pickerField<T: Hashable>(
        title: String,
        selection: Binding<T?>,
        values: [T],
        label: @escaping (T) -> String
    ) -> some View {
        Picker(title, selection: selection) {
            Text("-").tag(Optional<T>.none)
            ForEach(values, id: \.self) { value in
                Text(label(value)).tag(Optional(value))
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: .infinity)
        .frame(height: 38)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "E7E2DC"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func actionButton(title: String, primary: Bool) -> some View {
        Text(title)
            .font(.app(size: 13))
            .fontWeight(.bold)
            .foregroundColor(primary ? .white : Color(hex: "5A341F"))
            .frame(maxWidth: .infinity)
            .frame(height: 42)
            .background(primary ? Color(hex: "8B5E3C") : Color(hex: "E9D7C7"))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(primary ? Color.clear : Color(hex: "7C4A2D"), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct RecipeDraftPreviewSheet: View {
    let recipe: RecipeItem

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(recipe.title)
                        .font(.app(size: 24))
                        .fontWeight(.bold)

                    Text(recipe.summary)
                        .font(.app(size: 13))
                        .foregroundColor(Color(hex: "6A625B"))

                    ForEach(recipe.steps) { step in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(step.stepOrder). \(step.description)")
                                .font(.app(size: 13))
                            Text("\(step.durationSec)s / \(Int(step.waterAmountMl ?? 0))ml")
                                .font(.app(size: 11))
                                .foregroundColor(Color(hex: "6A625B"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color(hex: "FCFAF8"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "E8E1DA"), lineWidth: 1)
                        )
                    }
                }
                .padding(14)
            }
            .navigationTitle(L10n.text("compose.preview", default: "Preview"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecipeComposeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeComposeView()
            .environmentObject(AppViewModel())
            .environmentObject(RecipeRepository())
    }
}
