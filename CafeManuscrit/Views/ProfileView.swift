import SwiftUI

struct ProfileView: View {
    private enum Section: String, CaseIterable, Identifiable {
        case bookmarks
        case myRecipes

        var id: String { rawValue }

        var title: String {
            switch self {
            case .bookmarks:
                return L10n.text("profile.section.bookmarks", default: "북마크")
            case .myRecipes:
                return L10n.text("profile.section.my_recipes", default: "내 레시피")
            }
        }
    }

    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var repository: RecipeRepository
    @State private var selectedSection: Section = .bookmarks

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    profileHeader

                    if appViewModel.isLoggedIn {
                        sectionPicker
                        sectionContent
                        logoutButton
                    } else {
                        loggedOutActions
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 16)
                .padding(.bottom, 96)
            }
            .background(Color(hex: "FFFFFF"))
            .navigationTitle(L10n.text("profile.title", default: "프로필"))
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(Color(hex: "E9D7C7"))
                .frame(width: 72, height: 72)
                .overlay(
                    Text(initial)
                        .font(.app(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "7C4A2D"))
                )

            Text(displayName)
                .font(.app(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "1F1A16"))

            Text(appViewModel.isLoggedIn
                ? L10n.text("profile.logged_in", default: "내 레시피와 북마크를 관리하세요")
                : L10n.text("profile.logged_out", default: "로그인해 프로필을 완성해 보세요"))
            .font(.app(size: 13))
            .foregroundColor(Color(hex: "6A625B"))
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var loggedOutActions: some View {
        Button {
            appViewModel.requireLogin()
        } label: {
            Text(L10n.text("profile.login", default: "로그인"))
                .font(.app(size: 14))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(Color(hex: "8B5E3C"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private var sectionPicker: some View {
        HStack(spacing: 8) {
            ForEach(Section.allCases) { section in
                Button {
                    selectedSection = section
                } label: {
                    Text(section.title)
                        .font(.app(size: 12))
                        .fontWeight(selectedSection == section ? .bold : .semibold)
                        .foregroundColor(selectedSection == section ? Color(hex: "5A341F") : Color(hex: "6A625B"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                        .background(selectedSection == section ? Color(hex: "E9D7C7") : Color(hex: "F3F1EE"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedSection == section ? Color(hex: "7C4A2D") : Color.clear, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var sectionContent: some View {
        switch selectedSection {
        case .bookmarks:
            bookmarkList
        case .myRecipes:
            myRecipesList
        }
    }

    private var bookmarkList: some View {
        let recipes = repository.bookmarkedRecipes()
        return VStack(spacing: 12) {
            if recipes.isEmpty {
                emptyState(
                    title: L10n.text("bookmark.empty.title", default: "저장한 레시피가 없습니다"),
                    subtitle: L10n.text("bookmark.empty.subtitle", default: "마음에 드는 레시피를 저장해 보세요")
                )
            } else {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipeID: recipe.id)
                    } label: {
                        RecipeFeedCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var myRecipesList: some View {
        let name = appViewModel.currentUser?.name ?? ""
        let recipes = repository.recipes
            .filter { $0.authorName == name }
            .sorted { $0.createdAt > $1.createdAt }

        return VStack(spacing: 12) {
            if recipes.isEmpty {
                emptyState(
                    title: L10n.text("profile.my_recipes.empty.title", default: "내 레시피가 없습니다"),
                    subtitle: L10n.text("profile.my_recipes.empty.subtitle", default: "브루 탭에서 첫 레시피를 작성해 보세요")
                )
            } else {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipeID: recipe.id)
                    } label: {
                        RecipeFeedCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func emptyState(title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.app(size: 15))
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "2F2721"))

            Text(subtitle)
                .font(.app(size: 12))
                .foregroundColor(Color(hex: "6A625B"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(hex: "FCFAF8"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E8E1DA"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var logoutButton: some View {
        Button {
            appViewModel.logout()
        } label: {
            Text(L10n.text("profile.logout", default: "로그아웃"))
                .font(.app(size: 14))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(Color(hex: "8B5E3C"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private var displayName: String {
        appViewModel.currentUser?.name ?? L10n.text("profile.guest", default: "Guest")
    }

    private var initial: String {
        String(displayName.prefix(1)).uppercased()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppViewModel())
            .environmentObject(RecipeRepository())
    }
}
