//
//  RoastLevel.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import Foundation

enum RoastLevel: String, CaseIterable, Codable {
    case light = "Light"
    case mediumLight = "Medium Light"
    case medium = "Medium"
    case mediumDark = "Medium Dark"
    case dark = "Dark"
    
    var displayName: String {
        switch self {
        case .light:
            return L10n.text("domain.roast_level.light", default: "Light Roast")
        case .mediumLight:
            return L10n.text("domain.roast_level.medium_light", default: "Medium Light")
        case .medium:
            return L10n.text("domain.roast_level.medium", default: "Medium")
        case .mediumDark:
            return L10n.text("domain.roast_level.medium_dark", default: "Medium Dark")
        case .dark:
            return L10n.text("domain.roast_level.dark", default: "Dark Roast")
        }
    }
    
    var color: String {
        switch self {
        case .light:
            return "#B17A4B"
        case .mediumLight:
            return "#9A6338"
        case .medium:
            return "#7E4F2E"
        case .mediumDark:
            return "#4A2E1F"
        case .dark:
            return "#1A1A1A"
        }
    }
}
