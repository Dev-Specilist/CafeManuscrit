//
//  BookmarkModel.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/8/25.
//

import Foundation
import SwiftData

@Model
final class BookmarkModel {
    @Attribute(.unique) var id: String
    var createdAt: Date
    
    // 관계 설정
    @Relationship var user: UserModel?
    @Relationship var recipe: RecipeModel?
    
    init(user: UserModel, recipe: RecipeModel) {
        self.id = UUID().uuidString
        self.user = user
        self.recipe = recipe
        self.createdAt = Date()
    }
}
