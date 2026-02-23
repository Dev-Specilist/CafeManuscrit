//
//  Recipe.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let author: User
    let coffeeBean: CoffeeBean
    let brewMethod: BrewMethod
    let waterTemperature: Int // Celsius
    let coffeeToWaterRatio: String // e.g. "1:15"
    let brewTime: TimeInterval // seconds
    let steps: [BrewStep]
    let imageUrl: String?
    let tags: [String]
    let rating: Double
    let bookmarkCount: Int
    let createdAt: Date
    
    // Dummy data
    static let dummyFeaturedRecipes: [Recipe] = [
        Recipe(
            id: "recipe_001",
            title: "Golden Ratio V60",
            description: "A balanced V60 recipe with a clean finish.",
            author: User.dummyUser,
            coffeeBean: CoffeeBean.dummyBean1,
            brewMethod: .v60,
            waterTemperature: 93,
            coffeeToWaterRatio: "1:15",
            brewTime: 240,
            steps: BrewStep.dummySteps,
            imageUrl: nil,
            tags: ["V60", "Balanced", "Beginner"],
            rating: 4.8,
            bookmarkCount: 124,
            createdAt: Date()
        ),
        Recipe(
            id: "recipe_002",
            title: "Ethiopian Yirgacheffe Special",
            description: "A bright and fruity cup using Ethiopian beans.",
            author: User.dummyUser,
            coffeeBean: CoffeeBean.dummyBean2,
            brewMethod: .chemex,
            waterTemperature: 95,
            coffeeToWaterRatio: "1:16",
            brewTime: 300,
            steps: BrewStep.dummySteps,
            imageUrl: nil,
            tags: ["Ethiopia", "Fruity", "Chemex"],
            rating: 4.6,
            bookmarkCount: 89,
            createdAt: Date()
        )
    ]
    
    static let dummyRecentRecipes: [Recipe] = [
        Recipe(
            id: "recipe_003",
            title: "Easy Morning Drip",
            description: "A quick recipe for busy mornings.",
            author: User.dummyUser,
            coffeeBean: CoffeeBean.dummyBean1,
            brewMethod: .pourOver,
            waterTemperature: 92,
            coffeeToWaterRatio: "1:14",
            brewTime: 180,
            steps: BrewStep.dummySteps,
            imageUrl: nil,
            tags: ["Easy", "Morning", "Quick"],
            rating: 4.3,
            bookmarkCount: 45,
            createdAt: Date()
        ),
        Recipe(
            id: "recipe_004",
            title: "Rich Cup for Bold Coffee Lovers",
            description: "For those who want a full body and deep taste.",
            author: User.dummyUser,
            coffeeBean: CoffeeBean.dummyBean2,
            brewMethod: .frenchPress,
            waterTemperature: 96,
            coffeeToWaterRatio: "1:12",
            brewTime: 240,
            steps: BrewStep.dummySteps,
            imageUrl: nil,
            tags: ["Bold", "Body", "French Press"],
            rating: 4.7,
            bookmarkCount: 78,
            createdAt: Date()
        )
    ]
}
