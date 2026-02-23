import SwiftUI
import UIKit

enum PenIconKind {
    case home
    case search
    case coffeeMaker
    case person
    case add
    case star
    case history
    case bookmark
}

struct PenIcon: View {
    let kind: PenIconKind
    let size: CGFloat
    let color: Color

    private static let materialFontCandidates = [
        "Material Symbols Rounded",
        "MaterialSymbolsRounded"
    ]

    private var materialFontName: String? {
        Self.materialFontCandidates.first { UIFont(name: $0, size: size) != nil }
    }

    var body: some View {
        Group {
            if let fontName = materialFontName {
                Text(materialLigature)
                    .font(.custom(fontName, size: size))
            } else {
                if kind == .coffeeMaker {
                    Image("coffee_maker")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: size, height: size)
                } else {
                    Image(systemName: fallbackSymbol)
                        .font(.system(size: size, weight: .semibold))
                }
            }
        }
        .foregroundColor(color)
    }

    private var materialLigature: String {
        switch kind {
        case .home:
            return "home"
        case .search:
            return "search"
        case .coffeeMaker:
            return "coffee_maker"
        case .person:
            return "person"
        case .add:
            return "add"
        case .star:
            return "star"
        case .history:
            return "history"
        case .bookmark:
            return "bookmark"
        }
    }

    private var fallbackSymbol: String {
        switch kind {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .coffeeMaker:
            return "cup.and.saucer"
        case .person:
            return "person"
        case .add:
            return "plus"
        case .star:
            return "star"
        case .history:
            return "clock.arrow.circlepath"
        case .bookmark:
            return "bookmark"
        }
    }
}
