//
//  UserModel.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/4/25.
//

import Foundation
import SwiftData

@Model
final class UserModel {
    @Attribute(.unique) var id: String
    var name: String
    var email: String
    var profileImageUrl: String?
    var createdAt: Date
    
    // 관계 설정
    @Relationship(deleteRule: .cascade, inverse: \RecipeModel.author)
    var recipes: [RecipeModel] = []
    
    @Relationship(deleteRule: .cascade, inverse: \BookmarkModel.user)
    var bookmarks: [BookmarkModel] = []
    
    init(id: String, name: String, email: String, profileImageUrl: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.createdAt = Date()
    }
    
    // User 구조체로 변환
    func toUser() -> User {
        return User(
            id: id,
            name: name,
            email: email,
            profileImageUrl: profileImageUrl,
            createdAt: createdAt
        )
    }
    
    // User 구조체에서 생성
    static func from(_ user: User) -> UserModel {
        return UserModel(
            id: user.id,
            name: user.name,
            email: user.email,
            profileImageUrl: user.profileImageUrl
        )
    }
}

