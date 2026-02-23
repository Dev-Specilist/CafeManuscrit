//
//  BrewMethod.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import Foundation

enum BrewMethod: String, CaseIterable, Codable {
    case v60 = "V60"
    case chemex = "Chemex"
    case aeropress = "AeroPress"
    case frenchPress = "French Press"
    case pourOver = "Pour Over"
    case kalita = "Kalita Wave"
    
    var displayName: String {
        switch self {
        case .v60:
            return L10n.text("domain.brew_method.v60", default: "V60")
        case .chemex:
            return L10n.text("domain.brew_method.chemex", default: "Chemex")
        case .aeropress:
            return L10n.text("domain.brew_method.aeropress", default: "AeroPress")
        case .frenchPress:
            return L10n.text("domain.brew_method.french_press", default: "French Press")
        case .pourOver:
            return L10n.text("domain.brew_method.pour_over", default: "Pour Over")
        case .kalita:
            return L10n.text("domain.brew_method.kalita", default: "Kalita Wave")
        }
    }
    
    var icon: String {
        switch self {
        case .v60:
            return "drop.triangle"
        case .chemex:
            return "flask"
        case .aeropress:
            return "cylinder"
        case .frenchPress:
            return "cup.and.saucer"
        case .pourOver:
            return "drop"
        case .kalita:
            return "circle.grid.3x3"
        }
    }
}
