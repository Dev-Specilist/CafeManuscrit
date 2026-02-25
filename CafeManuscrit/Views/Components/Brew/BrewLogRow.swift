import SwiftUI

struct BrewLogRow: View {
    let title: String
    let subtitle: String
    var isSelected: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.app(size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "2F2721"))
            Text(subtitle)
                .font(.app(size: 11))
                .foregroundColor(Color(hex: "6A625B"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(isSelected ? Color(hex: "F8F4EF") : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color(hex: "E8DED4") : Color(hex: "E7E2DC"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
