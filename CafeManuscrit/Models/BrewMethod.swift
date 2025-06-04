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
            return "V60"
        case .chemex:
            return "케멕스"
        case .aeropress:
            return "에어로프레스"
        case .frenchPress:
            return "프렌치프레스"
        case .pourOver:
            return "푸어오버"
        case .kalita:
            return "칼리타 웨이브"
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
