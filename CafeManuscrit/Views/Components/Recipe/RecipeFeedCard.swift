import SwiftUI

struct RecipeFeedCard: View {
    let recipe: RecipeItem

    var body: some View {
        HStack(spacing: 14) {
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
            .frame(width: 92, height: 92)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F1A16"))
                    .lineLimit(2)

                Text("by \(recipe.authorName)")
                    .font(.custom("Inter", size: 11))
                    .foregroundColor(Color(hex: "6A625B"))

                Text(recipe.cardMetaLine)
                    .font(.custom("Inter", size: 11))
                    .foregroundColor(Color(hex: "8B5E3C"))
                    .lineLimit(1)

                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        PenIcon(kind: .star, size: 12, color: Color(hex: "F4A261"))
                        Text("\(recipe.likeCount)")
                            .font(.custom("Inter", size: 10))
                            .foregroundColor(Color(hex: "5E5852"))
                    }

                    if recipe.isBookmarked {
                        HStack(spacing: 4) {
                            PenIcon(kind: .bookmark, size: 12, color: Color(hex: "C18D59"))
                            Text(L10n.text("bookmark.saved", default: "Saved"))
                                .font(.custom("Inter", size: 10))
                                .foregroundColor(Color(hex: "5E5852"))
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(minHeight: 112)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "E7E2DC"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
