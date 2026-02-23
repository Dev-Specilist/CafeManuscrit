import SwiftUI

struct RecipeDetailView: View {
    let recipeID: String

    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var repository: RecipeRepository

    @State private var showLoginPrompt = false
    @State private var showTimer = false
    @State private var toastMessage: String?
    @State private var isLikeLoading = false
    @State private var isBookmarkLoading = false

    private var recipe: RecipeItem? {
        repository.recipe(id: recipeID)
    }

    var body: some View {
        Group {
            if let recipe {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        hero(recipe)
                        metaSection(recipe)
                        stepSection(recipe)
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 14)
                    .padding(.bottom, 120)
                }
                .background(Color(hex: "FFFFFF"))
                .safeAreaInset(edge: .bottom) {
                    actionBar(recipe)
                }
            } else {
                VStack(spacing: 12) {
                    Text(L10n.text("detail.not_found", default: "레시피를 찾을 수 없습니다."))
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(Color(hex: "6A625B"))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "FFFFFF"))
            }
        }
        .navigationTitle(L10n.text("detail.title", default: "레시피 상세"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showLoginPrompt) {
            AuthPromptSheet(
                title: L10n.text("auth.prompt.title", default: "로그인이 필요합니다"),
                message: L10n.text("auth.prompt.message", default: "좋아요, 북마크, 글쓰기는 로그인 후 이용할 수 있어요."),
                onLogin: { appViewModel.requireLogin() }
            )
        }
        .fullScreenCover(isPresented: $showTimer) {
            if let recipe {
                BrewTimerView(recipe: recipe)
            }
        }
        .overlay(alignment: .top) {
            if let toastMessage {
                Text(toastMessage)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Capsule())
                    .padding(.top, 12)
                    .transition(.opacity)
            }
        }
    }

    private func hero(_ recipe: RecipeItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: recipe.imageURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color(hex: "EDE6DE")
                }
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(recipe.title)
                .font(.custom("Inter", size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "1F1A16"))

            Text("by \(recipe.authorName)")
                .font(.custom("Inter", size: 13))
                .foregroundColor(Color(hex: "6A625B"))

            if !recipe.summary.isEmpty {
                Text(recipe.summary)
                    .font(.custom("Inter", size: 13))
                    .foregroundColor(Color(hex: "5E5852"))
            }
        }
    }

    private func metaSection(_ recipe: RecipeItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.text("detail.meta", default: "메타 정보"))
                .font(.custom("Inter", size: 16))
                .fontWeight(.semibold)

            VStack(spacing: 8) {
                detailMetaRow(
                    L10n.text("detail.bean", default: "원두"),
                    "\(recipe.beanName) · \(recipe.beanOrigin) · \(recipe.roastLevel.displayName)"
                )
                detailMetaRow(
                    L10n.text("detail.brew", default: "추출"),
                    "\(recipe.brewMethod.displayName) · \(recipe.grindSize.title)"
                )
                detailMetaRow(
                    L10n.text("detail.grinder", default: "그라인더"),
                    "\(recipe.grinderName) \(recipe.grinderSetting)"
                )
                detailMetaRow(
                    L10n.text("detail.water", default: "물"),
                    "\(recipe.waterTemperature)°C · \(recipe.coffeeRatioText)"
                )
                detailMetaRow(
                    L10n.text("detail.total", default: "총 추출 시간"),
                    recipe.totalTimeText
                )
            }
        }
        .padding(14)
        .background(Color(hex: "FCFAF8"))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "E8E1DA"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func detailMetaRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(title)
                .font(.custom("Inter", size: 12))
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "6A625B"))
                .frame(width: 84, alignment: .leading)

            Text(value)
                .font(.custom("Inter", size: 12))
                .foregroundColor(Color(hex: "2F2721"))

            Spacer(minLength: 0)
        }
    }

    private func stepSection(_ recipe: RecipeItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.text("detail.steps", default: "브루 스텝"))
                .font(.custom("Inter", size: 16))
                .fontWeight(.semibold)

            VStack(spacing: 8) {
                ForEach(recipe.steps) { step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(step.stepOrder)")
                            .font(.custom("Inter", size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "8B5E3C"))
                            .frame(width: 20, alignment: .leading)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.description)
                                .font(.custom("Inter", size: 13))
                                .foregroundColor(Color(hex: "1F1A16"))

                            Text("\(step.durationSec)s · \(Int(step.waterAmountMl ?? 0))ml")
                                .font(.custom("Inter", size: 11))
                                .foregroundColor(Color(hex: "6A625B"))
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "EEE6DD"), lineWidth: 1)
                    )
                }
            }
        }
    }

    private func actionBar(_ recipe: RecipeItem) -> some View {
        HStack(spacing: 8) {
            Button {
                onTapLike(recipe)
            } label: {
                Text(recipe.isLiked ? "♥ \(recipe.likeCount)" : "♡ \(recipe.likeCount)")
                    .font(.custom("Inter", size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "7C4A2D"))
                    .frame(minWidth: 72)
                    .frame(height: 42)
                    .background(Color(hex: "F2E5D8"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(isLikeLoading)

            Button {
                onTapBookmark(recipe)
            } label: {
                Text(recipe.isBookmarked ? L10n.text("detail.bookmark.on", default: "저장됨") : L10n.text("detail.bookmark.off", default: "북마크"))
                    .font(.custom("Inter", size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "7C4A2D"))
                    .frame(minWidth: 84)
                    .frame(height: 42)
                    .background(Color(hex: "F2E5D8"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(isBookmarkLoading)

            Button {
                showTimer = true
            } label: {
                Text(L10n.text("detail.timer.start", default: "타이머 시작"))
                    .font(.custom("Inter", size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color(hex: "8B5E3C"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(Color.white)
    }

    private func onTapLike(_ recipe: RecipeItem) {
        guard appViewModel.isLoggedIn else {
            showLoginPrompt = true
            return
        }

        guard !isLikeLoading else {
            return
        }

        isLikeLoading = true
        Task {
            do {
                _ = try await repository.toggleLike(recipeID: recipe.id)
            } catch {
                showToast(error.localizedDescription)
            }
            isLikeLoading = false
        }
    }

    private func onTapBookmark(_ recipe: RecipeItem) {
        guard appViewModel.isLoggedIn else {
            showLoginPrompt = true
            return
        }

        guard !isBookmarkLoading else {
            return
        }

        isBookmarkLoading = true
        Task {
            do {
                _ = try await repository.toggleBookmark(recipeID: recipe.id)
            } catch {
                showToast(error.localizedDescription)
            }
            isBookmarkLoading = false
        }
    }

    private func showToast(_ message: String) {
        toastMessage = message
        Task {
            try? await Task.sleep(for: .seconds(2))
            if !Task.isCancelled {
                toastMessage = nil
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeDetailView(recipeID: "r1")
                .environmentObject(AppViewModel())
                .environmentObject(RecipeRepository())
        }
    }
}
