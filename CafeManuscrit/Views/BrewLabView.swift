import SwiftUI

struct BrewLabView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var repository: RecipeRepository

    @State private var expandedRecipeID: String?
    @State private var hiddenRecipeIDs: Set<String> = []
    @State private var showTimer = false
    @State private var showCompose = false
    @State private var showAuthPrompt = false

    private var visibleRecipes: [RecipeItem] {
        repository.recipes
            .filter { !hiddenRecipeIDs.contains($0.id) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    private var expandedRecipe: RecipeItem? {
        guard let expandedRecipeID else { return visibleRecipes.first }
        return visibleRecipes.first(where: { $0.id == expandedRecipeID }) ?? visibleRecipes.first
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                header

                VStack(spacing: 10) {
                    ForEach(visibleRecipes) { recipe in
                        if recipe.id == expandedRecipe?.id {
                            BrewRecipeCard(
                                title: "\(recipe.brewMethod.displayName) · \(recipe.beanName)",
                                meta: "\(Int(recipe.coffeeAmountG))g in · \(Int(recipe.waterAmountMl))g out · \(recipe.totalTimeText)",
                                chips: [
                                    String(format: "Ratio 1:%.1f", recipe.waterAmountMl / max(1, recipe.coffeeAmountG)),
                                    "Temp \(recipe.waterTemperature)°C"
                                ],
                                ctaLabel: L10n.text("brew.quick.cta.start", default: "Start Brew"),
                                onCTATap: { showTimer = true }
                            )
                        } else {
                            SwipeToDeleteRow(
                                deleteTitle: L10n.text("brew.delete", default: "Delete"),
                                onDelete: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        hiddenRecipeIDs.insert(recipe.id)
                                        if expandedRecipeID == recipe.id {
                                            expandedRecipeID = nil
                                        }
                                    }
                                },
                                onActivate: {
                                    withAnimation(.easeInOut(duration: 0.18)) {
                                        expandedRecipeID = recipe.id
                                    }
                                }
                            ) {
                                BrewLogRow(
                                    title: "\(recipe.brewMethod.displayName) · \(recipe.beanName)",
                                    subtitle: "\(Int(recipe.coffeeAmountG))g / \(Int(recipe.waterAmountMl))g · \(recipe.totalTimeText) · \(recipe.summary)",
                                    isSelected: false
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(hex: "FFFFFF"))
        .onAppear {
            if expandedRecipeID == nil {
                expandedRecipeID = visibleRecipes.first?.id
            }
        }
        .onChange(of: visibleRecipes.map(\.id)) { _, ids in
            if ids.isEmpty {
                expandedRecipeID = nil
                return
            }
            if let expandedRecipeID, ids.contains(expandedRecipeID) {
                return
            }
            expandedRecipeID = ids.first
        }
        .sheet(isPresented: $showCompose) {
            RecipeComposeView()
                .environmentObject(appViewModel)
                .environmentObject(repository)
        }
        .sheet(isPresented: $showAuthPrompt) {
            AuthPromptSheet(
                title: L10n.text("auth.prompt.title", default: "로그인이 필요합니다"),
                message: L10n.text("auth.prompt.message", default: "좋아요, 북마크, 글쓰기는 로그인 후 이용할 수 있어요."),
                onLogin: { appViewModel.requireLogin() }
            )
        }
        .fullScreenCover(isPresented: $showTimer) {
            if let expandedRecipe {
                BrewTimerView(recipe: expandedRecipe)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(L10n.text("brew.lab.title", default: "Brew Lab"))
                    .font(.app(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F1A16"))

                Spacer()

                Button {
                    if appViewModel.isLoggedIn {
                        showCompose = true
                    } else {
                        showAuthPrompt = true
                    }
                } label: {
                    PenIcon(kind: .add, size: 20, color: Color(hex: "8B5E3C"))
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 30)

            Text(L10n.text("brew.lab.subtitle", default: "Dial in your recipe and track each extraction."))
                .font(.app(size: 12))
                .foregroundColor(Color(hex: "6A625B"))
                .lineSpacing(2)
        }
    }
}

private struct SwipeToDeleteRow<Content: View>: View {
    let deleteTitle: String
    let onDelete: () -> Void
    let onActivate: () -> Void
    let content: Content

    @State private var settledReveal: CGFloat = 0
    @GestureState private var dragRevealDelta: CGFloat = 0

    private let buttonSize: CGFloat = 56
    private let maxReveal: CGFloat = 76
    private let revealThreshold: CGFloat = 28

    init(
        deleteTitle: String,
        onDelete: @escaping () -> Void,
        onActivate: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.deleteTitle = deleteTitle
        self.onDelete = onDelete
        self.onActivate = onActivate
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            deleteButton

            content
                .frame(height: 66)
                .contentShape(Rectangle())
                .offset(x: -currentReveal)
                .highPriorityGesture(dragGesture)
                .onTapGesture {
                    if currentReveal > 0 {
                        withAnimation(.easeInOut(duration: 0.16)) {
                            settledReveal = 0
                        }
                    } else {
                        onActivate()
                    }
                }
        }
        .frame(height: 66)
    }

    private var currentReveal: CGFloat {
        max(0, min(maxReveal, settledReveal + dragRevealDelta))
    }

    private var revealProgress: CGFloat {
        guard maxReveal > 0 else { return 0 }
        return min(1, currentReveal / maxReveal)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .updating($dragRevealDelta) { value, state, _ in
                let revealDelta = -value.translation.width
                let tentative = settledReveal + revealDelta
                let clamped = max(0, min(maxReveal, tentative))
                state = clamped - settledReveal
            }
            .onEnded { value in
                let revealDelta = -value.translation.width
                let tentative = settledReveal + revealDelta
                let clamped = max(0, min(maxReveal, tentative))

                withAnimation(.easeInOut(duration: 0.16)) {
                    settledReveal = clamped >= revealThreshold ? maxReveal : 0
                }
            }
    }

    private var deleteButton: some View {
        Circle()
            .fill(Color(hex: "D94A4A"))
            .frame(width: buttonSize, height: buttonSize)
            .overlay(
                VStack(spacing: 2) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text(deleteTitle)
                        .font(.app(size: 9))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.16)) {
                    settledReveal = 0
                }
                onDelete()
            }
            .opacity(revealProgress)
            .scaleEffect(0.82 + 0.18 * revealProgress)
            .offset(x: (1 - revealProgress) * 12)
            .animation(.easeInOut(duration: 0.12), value: revealProgress)
            .padding(.trailing, 8)
            .allowsHitTesting(currentReveal > 8)
    }
}

struct BrewLabView_Previews: PreviewProvider {
    static var previews: some View {
        BrewLabView()
            .environmentObject(AppViewModel())
            .environmentObject(RecipeRepository())
    }
}
