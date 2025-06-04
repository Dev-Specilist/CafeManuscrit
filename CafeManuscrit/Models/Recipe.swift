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
    let waterTemperature: Int // 섭씨
    let coffeeToWaterRatio: String // "1:15" 형태
    let brewTime: TimeInterval // 초
    let steps: [BrewStep]
    let imageUrl: String?
    let tags: [String]
    let rating: Double
    let bookmarkCount: Int
    let createdAt: Date
    
    // 더미 데이터
    static let dummyFeaturedRecipes: [Recipe] = [
        Recipe(
            id: "recipe_001",
            title: "황금비율 V60 레시피",
            description: "완벽한 밸런스의 V60 드립 레시피입니다.",
            author: User.dummyUser,
            coffeeBean: CoffeeBean.dummyBean1,
            brewMethod: .v60,
            waterTemperature: 93,
            coffeeToWaterRatio: "1:15",
            brewTime: 240,
            steps: BrewStep.dummySteps,
            imageUrl: nil,
            tags: ["V60", "밸런스", "초보자"],
            rating: 4.8,
            bookmarkCount: 124,
            createdAt: Date()
        ),
        Recipe(
            id: "recipe_002",
            title: "에티오피아 예가체프 특제",
            description: "과일향이 풍부한 에티오피아 원두로 만드는 특별한 레시피",
            author: User.dummyUser,
            coffeeBean: CoffeeBean.dummyBean2,
            brewMethod: .chemex,
            waterTemperature: 95,
            coffeeToWaterRatio: "1:16",
            brewTime: 300,
            steps: BrewStep.dummySteps,
            imageUrl: nil,
            tags: ["에티오피아", "과일향", "케멕스"],
            rating: 4.6,
            bookmarkCount: 89,
            createdAt: Date()
        )
    ]
    
    static let dummyRecentRecipes: [Recipe] = [
        Recipe(
            id: "recipe_003",
            title: "아침을 위한 간단 드립",
            description: "바쁜 아침에도 쉽게 만들 수 있는 레시피",
            author: User.dummyUser,
            coffeeBean: CoffeeBean.dummyBean1,
            brewMethod: .pourOver,
            waterTemperature: 92,
            coffeeToWaterRatio: "1:14",
            brewTime: 180,
            steps: BrewStep.dummySteps,
            imageUrl: nil,
            tags: ["간단", "아침", "빠른"],
            rating: 4.3,
            bookmarkCount: 45,
            createdAt: Date()
        ),
        Recipe(
            id: "recipe_004",
            title: "진한 커피 애호가를 위한 레시피",
            description: "강한 바디감과 깊은 맛을 원하는 분들께",
            author: User.dummyUser,
            coffeeBean: CoffeeBean.dummyBean2,
            brewMethod: .frenchPress,
            waterTemperature: 96,
            coffeeToWaterRatio: "1:12",
            brewTime: 240,
            steps: BrewStep.dummySteps,
            imageUrl: nil,
            tags: ["진한맛", "바디감", "프렌치프레스"],
            rating: 4.7,
            bookmarkCount: 78,
            createdAt: Date()
        )
    ]
}
