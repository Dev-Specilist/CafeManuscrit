//
//  AuthDTOs.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/4/25.
//

import Foundation

// MARK: - Login DTOs
struct LoginInput {
    let provider: SSOProvider
    let idToken: String
}

struct LoginOutput {
    let user: User
    let accessToken: String
    let refreshToken: String
}

// MARK: - Token Refresh DTOs
struct RefreshTokenInput {
    let refreshToken: String
}

struct RefreshTokenOutput {
    let accessToken: String
    let refreshToken: String?
}

// MARK: - SSO Provider
enum SSOProvider: String, CaseIterable {
    case apple = "apple"
    case google = "google"
    
    var displayName: String {
        switch self {
        case .apple:
            return "Apple"
        case .google:
            return "Google"
        }
    }
    
    var iconName: String {
        switch self {
        case .apple:
            return "applelogo"
        case .google:
            return "globe"
        }
    }
}
