import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject private var repository: RecipeRepository

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    if recipes.isEmpty {
                        VStack(spacing: 8) {
                            Text(L10n.text("bookmark.empty.title", default: "저장한 레시피가 없습니다"))
                                .font(.custom("Inter", size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "2F2721"))

                            Text(L10n.text("bookmark.empty.subtitle", default: "마음에 드는 레시피를 저장해 보세요"))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(Color(hex: "6A625B"))
                        }
                        .padding(.vertical, 28)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "FCFAF8"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "E8E1DA"), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                .padding(.horizontal, 14)
                .padding(.top, 14)
                .padding(.bottom, 12)
            }
            .background(Color(hex: "FFFFFF"))
            .navigationTitle(L10n.text("bookmark.title", default: "북마크"))
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var recipes: [RecipeItem] {
        repository.bookmarkedRecipes()
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
            .environmentObject(RecipeRepository())
    }
}
