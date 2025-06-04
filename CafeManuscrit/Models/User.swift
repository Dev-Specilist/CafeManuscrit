//
//  User.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let profileImageUrl: String?
    let createdAt: Date
    
    static let dummyUser = User(
        id: "user_001",
        name: "커피 마니아",
        email: "coffee@example.com",
        profileImageUrl: nil,
        createdAt: Date()
    )
}
