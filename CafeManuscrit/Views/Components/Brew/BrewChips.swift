import SwiftUI

// MARK: - BrewStatChip
struct BrewStatChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.custom("Inter", size: 11))
            .fontWeight(.semibold)
            .foregroundColor(Color(hex: "5B524B"))
            .frame(maxWidth: .infinity, minHeight: 34, alignment: .center)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "E8DED4"), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - BrewStepChip
struct BrewStepChip: View {
    let label: String
    var selected: Bool = false

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(selected ? Color(hex: "E9D7C7") : Color(hex: "F3F4F6"))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selected ? Color(hex: "7C4A2D") : .clear, lineWidth: 2)
            )
            .overlay(
                Text(label)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(selected ? .heavy : .bold)
                    .foregroundColor(selected ? Color(hex: "5A341F") : Color(hex: "6B7280"))
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - BrewControlButton
struct BrewControlButton: View {
    let text: String

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "DCCFC3"), lineWidth: 1)
            )
            .overlay(
                Text(text)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "6A625B"))
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - BrewSecondaryAction
struct BrewSecondaryAction: View {
    let text: String

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(hex: "E9D7C7"))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "7C4A2D"), lineWidth: 1)
            )
            .overlay(
                Text(text)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "5A341F"))
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
