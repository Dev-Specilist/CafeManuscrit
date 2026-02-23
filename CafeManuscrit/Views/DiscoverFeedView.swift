import SwiftUI

struct DiscoverFeedView: View {
    @EnvironmentObject private var repository: RecipeRepository

    @State private var query: String = ""
    @State private var selectedRecipeID: String?

    private var recipes: [RecipeItem] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else {
            return repository.recipes
        }

        return repository.recipes.filter { recipe in
            let haystack = [recipe.title, recipe.beanName, recipe.authorName] + recipe.tags
            return haystack.joined(separator: " ").lowercased().contains(trimmed)
        }
    }

    private var stories: [StoryItem] {
        let base = Array(Set(recipes.map(\.authorName))).sorted().prefix(2)
        if base.count == 2 {
            return [
                StoryItem(name: String(base[0]), borderColor: Color(hex: "B9835A"), fillColor: Color(hex: "E8DED4")),
                StoryItem(name: String(base[1]), borderColor: Color(hex: "8FAF9E"), fillColor: Color(hex: "EDE6DE"))
            ]
        }
        return [
            StoryItem(name: ContentText.Discover.story1, borderColor: Color(hex: "B9835A"), fillColor: Color(hex: "E8DED4")),
            StoryItem(name: ContentText.Discover.story2, borderColor: Color(hex: "8FAF9E"), fillColor: Color(hex: "EDE6DE"))
        ]
    }

    private var posts: [DiscoverPost] {
        Array(recipes.prefix(6)).map { recipe in
            DiscoverPost(
                recipeID: recipe.id,
                authorTag: "#\((recipe.tags.first ?? recipe.brewMethod.apiValue).replacingOccurrences(of: " ", with: "_"))",
                imageURL: recipe.imageURL ?? ""
            )
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                feedTop
                storyRow
                postList
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

    private var feedTop: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.text("discover.feed.title", default: "Discover Feed"))
                .font(.custom("Inter", size: 22))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "1F1A16"))

            HStack(spacing: 8) {
                PenIcon(kind: .search, size: 16, color: Color(hex: "8A8179"))

                TextField(
                    L10n.text("discover.feed.search.placeholder", default: "Search beans, recipes, cafes"),
                    text: $query
                )
                .font(.custom("Inter", size: 12))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "5A534D"))

                if !query.isEmpty {
                    Button {
                        query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "A49A90"))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 38)
            .background(Color(hex: "F5F1ED"))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "E7E2DC"), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private var storyRow: some View {
        HStack(spacing: 8) {
            ForEach(stories) { story in
                VStack(spacing: 6) {
                    Circle()
                        .fill(story.fillColor)
                        .overlay(
                            Circle()
                                .stroke(story.borderColor, lineWidth: 2)
                        )
                        .frame(width: 54, height: 54)

                    Text(story.name)
                        .font(.custom("Inter", size: 11))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "5E5650"))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 84)
    }

    private var postList: some View {
        VStack(spacing: 12) {
            ForEach(posts) { post in
                DiscoverPostCard(post: post)
                    .onTapGesture {
                        selectedRecipeID = post.recipeID
                    }
            }

            if posts.isEmpty {
                Text(L10n.text("search.empty.subtitle", default: "조건을 조금 완화해 보세요"))
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(Color(hex: "6A625B"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
        }
    }
}

private struct StoryItem: Identifiable {
    let id = UUID()
    let name: String
    let borderColor: Color
    let fillColor: Color
}

private struct DiscoverPost: Identifiable {
    let id = UUID()
    let recipeID: String
    let authorTag: String
    let imageURL: String
}

private struct DiscoverPostCard: View {
    let post: DiscoverPost

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.authorTag)
                .font(.custom("Inter", size: 13))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "2F2721"))

            AsyncImage(url: URL(string: post.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color(hex: "EDE6DE")
                }
            }
            .frame(height: 190)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(12)
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "E7E2DC"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct DiscoverFeedView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverFeedView()
            .environmentObject(RecipeRepository())
    }
}
