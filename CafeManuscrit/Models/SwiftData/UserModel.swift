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

// Models/SwiftData/RecipeModel.swift
import Foundation
import SwiftData

@Model
final class RecipeModel {
    @Attribute(.unique) var id: String
    var title: String
    var recipeDescription: String
    var brewMethodRaw: String
    var waterTemperature: Int
    var coffeeToWaterRatio: String
    var brewTime: TimeInterval
    var imageUrl: String?
    var rating: Double
    var bookmarkCount: Int
    var createdAt: Date
    
    // JSON으로 저장되는 복잡한 데이터들
    @Attribute(.externalStorage) var stepsData: Data?
    @Attribute(.externalStorage) var coffeeBeanData: Data?
    var tagsString: String // 쉼표로 구분된 태그들
    
    // 관계 설정
    @Relationship var author: UserModel?
    @Relationship(deleteRule: .cascade, inverse: \BookmarkModel.recipe)
    var bookmarks: [BookmarkModel] = []
    
    init(
        id: String,
        title: String,
        description: String,
        brewMethod: BrewMethod,
        waterTemperature: Int,
        coffeeToWaterRatio: String,
        brewTime: TimeInterval,
        imageUrl: String? = nil,
        rating: Double = 0.0,
        bookmarkCount: Int = 0,
        steps: [BrewStep] = [],
        coffeeBean: CoffeeBean? = nil,
        tags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.recipeDescription = description
        self.brewMethodRaw = brewMethod.rawValue
        self.waterTemperature = waterTemperature
        self.coffeeToWaterRatio = coffeeToWaterRatio
        self.brewTime = brewTime
        self.imageUrl = imageUrl
        self.rating = rating
        self.bookmarkCount = bookmarkCount
        self.createdAt = Date()
        self.tagsString = tags.joined(separator: ",")
        
        // 복잡한 객체들을 JSON 데이터로 저장
        self.stepsData = try? JSONEncoder().encode(steps)
        self.coffeeBeanData = try? JSONEncoder().encode(coffeeBean)
    }
    
    // 계산 프로퍼티들
    var brewMethod: BrewMethod {
        return BrewMethod(rawValue: brewMethodRaw) ?? .v60
    }
    
    var steps: [BrewStep] {
        guard let data = stepsData else { return [] }
        return (try? JSONDecoder().decode([BrewStep].class, from: data)) ?? []
    }
    
    var coffeeBean: CoffeeBean? {
        guard let data = coffeeBeanData else { return nil }
        return try? JSONDecoder().decode(CoffeeBean.self, from: data)
    }
    
    var tags: [String] {
        return tagsString.isEmpty ? [] : tagsString.components(separatedBy: ",")
    }
    
    // Recipe 구조체로 변환
    func toRecipe() -> Recipe {
        return Recipe(
            id: id,
            title: title,
            description: recipeDescription,
            author: author?.toUser() ?? User.dummyUser,
            coffeeBean: coffeeBean ?? CoffeeBean.dummyBean1,
            brewMethod: brewMethod,
            waterTemperature: waterTemperature,
            coffeeToWaterRatio: coffeeToWaterRatio,
            brewTime: brewTime,
            steps: steps,
            imageUrl: imageUrl,
            tags: tags,
            rating: rating,
            bookmarkCount: bookmarkCount,
            createdAt: createdAt
        )
    }
    
    // Recipe 구조체에서 생성
    static func from(_ recipe: Recipe, author: UserModel?) -> RecipeModel {
        let model = RecipeModel(
            id: recipe.id,
            title: recipe.title,
            description: recipe.description,
            brewMethod: recipe.brewMethod,
            waterTemperature: recipe.waterTemperature,
            coffeeToWaterRatio: recipe.coffeeToWaterRatio,
            brewTime: recipe.brewTime,
            imageUrl: recipe.imageUrl,
            rating: recipe.rating,
            bookmarkCount: recipe.bookmarkCount,
            steps: recipe.steps,
            coffeeBean: recipe.coffeeBean,
            tags: recipe.tags
        )
        model.author = author
        return model
    }
}

// Models/SwiftData/BookmarkModel.swift
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
