import SwiftUI

struct BrewRecipeCard: View {
    let title: String
    let meta: String
    let chips: [String]
    var statusText: String? = nil
    let ctaLabel: String
    let onCTATap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.app(size: 16))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "2F2721"))

            Text(meta)
                .font(.app(size: 12))
                .foregroundColor(Color(hex: "6A625B"))

            HStack(spacing: 8) {
                ForEach(chips, id: \.self) { chip in
                    BrewStatChip(text: chip)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 34, maxHeight: 34)

            if let status = statusText {
                Text(status)
                    .font(.app(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "7C4A2D"))
            }

            Button(action: onCTATap) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "8B5E3C"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .overlay(
                        Text(ctaLabel)
                            .font(.app(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(hex: "F8F4EF"))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "E8DED4"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
