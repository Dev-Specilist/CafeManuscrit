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
            return "라이트 로스트"
        case .mediumLight:
            return "미디엄 라이트"
        case .medium:
            return "미디엄"
        case .mediumDark:
            return "미디엄 다크"
        case .dark:
            return "다크 로스트"
        }
    }
    
    var color: String {
        switch self {
        case .light:
            return "🤎"
        case .mediumLight:
            return "🤎"
        case .medium:
            return "🤎"
        case .mediumDark:
            return "🖤"
        case .dark:
            return "⚫"
        }
    }
}
