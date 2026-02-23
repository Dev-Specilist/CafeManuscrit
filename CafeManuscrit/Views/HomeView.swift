import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var repository: RecipeRepository
    @State private var selectedRecipeID: String?
    @State private var sort: FeedSortOption = .latest

    private var sortedRecipes: [RecipeItem] {
        let recipes = repository.recipes
        switch sort {
        case .latest:
            return recipes.sorted { $0.createdAt > $1.createdAt }
        case .popular:
            return recipes.sorted { lhs, rhs in
                if lhs.likeCount == rhs.likeCount {
                    return lhs.createdAt > rhs.createdAt
                }
                return lhs.likeCount > rhs.likeCount
            }
        }
    }

    private var featuredRecipes: [RecipeItem] {
        Array(sortedRecipes.prefix(2))
    }

    private var latestRecipes: [RecipeItem] {
        Array(sortedRecipes.dropFirst(2).prefix(4))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                hero
                featuredSection
                latestSection
            }
            .padding(.horizontal, 14)
            .padding(.top, 16)
            .padding(.bottom, 8)
        }
        .background(Color(hex: "FFFFFF"))
        .sheet(
            isPresented: Binding(
                get: { selectedRecipeID != nil },
                set: { if !$0 { selectedRecipeID = nil } }
            )
        ) {
            if let recipeID = selectedRecipeID {
                NavigationStack {
                    RecipeDetailView(recipeID: recipeID)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(L10n.text("common.close", default: "닫기")) {
                                    selectedRecipeID = nil
                                }
                            }
                        }
                }
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.text("home.section.recommended.title", default: "Today's Recommended Recipe"))
                .font(.custom("Inter", size: 15))
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "2B241E"))

            Text(L10n.text("home.section.recommended.subtitle", default: "Based on your beans and flavor profile, pick a recipe you can brew right now."))
                .font(.custom("Inter", size: 11))
                .foregroundColor(Color(hex: "5E5852"))
                .lineSpacing(3.3)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                Button {
                    sort = .popular
                } label: {
                    HStack(spacing: 8) {
                        PenIcon(kind: .star, size: 14, color: Color(hex: "FFD66B"))
                        Text(L10n.text("home.section.recommended.action.view_picks", default: "View picks"))
                            .foregroundColor(.white)
                            .font(.custom("Inter", size: 11))
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 30)
                    .background(Color(hex: "8B5E3C"))
                    .clipShape(Capsule())
                }

                Button {
                    sort = .latest
                } label: {
                    Text(sort == .latest ? L10n.text("feed.sort.latest", default: "최신순") : L10n.text("feed.sort.popular", default: "인기순"))
                        .foregroundColor(Color(hex: "5A341F"))
                        .font(.custom("Inter", size: 11))
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                        .background(Color(hex: "F2E5D8"))
                        .clipShape(Capsule())
                }

                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(height: 140)
        .background(Color(hex: "F8F5F2"))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: "E8E1DA"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                PenIcon(kind: .star, size: 20, color: Color(hex: "F4A261"))
                Text(L10n.text("home.section.featured.title", default: "Featured Recipes"))
                    .font(.custom("Inter", size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "1F1A16"))
            }
            .frame(height: 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(featuredRecipes) { recipe in
                        HomeFeaturedRecipeCard(
                            title: recipe.title,
                            author: recipe.authorName,
                            meta: recipe.cardMetaLine,
                            imageURL: recipe.imageURL ?? ""
                        )
                        .onTapGesture {
                            selectedRecipeID = recipe.id
                        }
                    }
                }
            }
            .frame(height: 176)
        }
    }

    private var latestSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                PenIcon(kind: .history, size: 20, color: Color(hex: "5B8DEF"))
                Text(L10n.text("home.section.latest.title", default: "Latest Recipes"))
                    .font(.custom("Inter", size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "1F1A16"))
            }
            .frame(height: 24)

            VStack(spacing: 12) {
                ForEach(latestRecipes) { recipe in
                    HomeLatestRecipeRow(
                        title: recipe.title,
                        subtitle: "\(recipe.beanName) · \(recipe.roastLevel.displayName)",
                        imageURL: recipe.imageURL ?? ""
                    )
                    .onTapGesture {
                        selectedRecipeID = recipe.id
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(RecipeRepository())
    }
}
