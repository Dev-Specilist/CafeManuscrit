import SwiftUI

// MARK: - Featured Recipe Card (horizontal scroll)
struct HomeFeaturedRecipeCard: View {
    let title: String
    let author: String
    let meta: String
    let imageURL: String

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color(hex: "EDE6DE")
                }
            }
            .frame(maxWidth: .infinity, minHeight: 96, maxHeight: 96)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.app(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F1A16"))
                Text(
                    String(
                        format: L10n.text("common.recipe.by_author", default: "by %@"),
                        author
                    )
                )
                .font(.app(size: 10))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "6E6862"))
                Text(meta)
                    .font(.app(size: 10))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "A97442"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 186, height: 176)
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E4E0DA"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Latest Recipe Row (vertical list)
struct HomeLatestRecipeRow: View {
    let title: String
    let subtitle: String
    let imageURL: String
    let isBookmarked: Bool
    let onTap: () -> Void
    let onBookmarkTap: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onTap) {
                HStack(spacing: 14) {
                    AsyncImage(url: URL(string: imageURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Color(hex: "EDE6DE")
                        }
                    }
                    .frame(width: 88, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.app(size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "1F1A16"))

                        Text(subtitle)
                            .font(.app(size: 11))
                            .foregroundColor(Color(hex: "6C6762"))
                            .lineSpacing(2)
                    }

                    Spacer(minLength: 0)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onBookmarkTap) {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isBookmarked ? Color(hex: "C18D59") : Color(hex: "B5ADA5"))
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(height: 112)
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "E7E2DC"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
