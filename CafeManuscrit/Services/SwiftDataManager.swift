//
//  SwiftDataManager.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/4/25.
//

import Foundation
import SwiftData

@MainActor
class SwiftDataManager: ObservableObject {
    static let shared = SwiftDataManager()
    
    private init() {}
    
    // MARK: - Model Container
    lazy var container: ModelContainer = {
        let schema = Schema([
            UserModel.self,
            RecipeModel.self,
            BookmarkModel.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var context: ModelContext {
        container.mainContext
    }
    
    // MARK: - User Management
    
    func saveUser(_ user: User) throws {
        // 기존 사용자 확인
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate<UserModel> { $0.id == user.id }
        )
        
        let existingUsers = try context.fetch(descriptor)
        
        if let existingUser = existingUsers.first {
            // 기존 사용자 업데이트
            existingUser.name = user.name
            existingUser.email = user.email
            existingUser.profileImageUrl = user.profileImageUrl
        } else {
            // 새 사용자 생성
            let userModel = UserModel.from(user)
            context.insert(userModel)
        }
        
        try context.save()
    }
    
    func getCurrentUser() throws -> User? {
        let descriptor = FetchDescriptor<UserModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        
        let users = try context.fetch(descriptor)
        return users.first?.toUser()
    }
    
    func deleteUser(id: String) throws {
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate<UserModel> { $0.id == id }
        )
        
        let users = try context.fetch(descriptor)
        users.forEach { context.delete($0) }
        
        try context.save()
    }
    
    // MARK: - Recipe Management
    
    func saveRecipe(_ recipe: Recipe) throws {
        // 작성자 찾기
        let userDescriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate<UserModel> { $0.id == recipe.author.id }
        )
        let authors = try context.fetch(userDescriptor)
        let author = authors.first
        
        // 기존 레시피 확인
        let recipeDescriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate<RecipeModel> { $0.id == recipe.id }
        )
        let existingRecipes = try context.fetch(recipeDescriptor)
        
        if let existingRecipe = existingRecipes.first {
            // 기존 레시피 업데이트
            existingRecipe.title = recipe.title
            existingRecipe.recipeDescription = recipe.description
            existingRecipe.brewMethodRaw = recipe.brewMethod.rawValue
            existingRecipe.waterTemperature = recipe.waterTemperature
            existingRecipe.coffeeToWaterRatio = recipe.coffeeToWaterRatio
            existingRecipe.brewTime = recipe.brewTime
            existingRecipe.imageUrl = recipe.imageUrl
            existingRecipe.rating = recipe.rating
            existingRecipe.bookmarkCount = recipe.bookmarkCount
            existingRecipe.tagsString = recipe.tags.joined(separator: ",")
            existingRecipe.stepsData = try? JSONEncoder().encode(recipe.steps)
            existingRecipe.coffeeBeanData = try? JSONEncoder().encode(recipe.coffeeBean)
            existingRecipe.author = author
        } else {
            // 새 레시피 생성
            let recipeModel = RecipeModel.from(recipe, author: author)
            context.insert(recipeModel)
        }
        
        try context.save()
    }
    
    func fetchUserRecipes(userId: String) throws -> [Recipe] {
        let descriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate<RecipeModel> { $0.author?.id == userId },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        let recipes = try context.fetch(descriptor)
        return recipes.map { $0.toRecipe() }
    }
    
    func fetchAllRecipes() throws -> [Recipe] {
        let descriptor = FetchDescriptor<RecipeModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        let recipes = try context.fetch(descriptor)
        return recipes.map { $0.toRecipe() }
    }
    
    func fetchFeaturedRecipes() throws -> [Recipe] {
        let descriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate<RecipeModel> { $0.rating >= 4.5 },
            sortBy: [SortDescriptor(\.rating, order: .reverse)]
        )
        descriptor.fetchLimit = 10
        
        let recipes = try context.fetch(descriptor)
        return recipes.map { $0.toRecipe() }
    }
    
    func deleteRecipe(id: String) throws {
        let descriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate<RecipeModel> { $0.id == id }
        )
        
        let recipes = try context.fetch(descriptor)
        recipes.forEach { context.delete($0) }
        
        try context.save()
    }
    
    // MARK: - Bookmark Management
    
    func addBookmark(userId: String, recipeId: String) throws {
        // 사용자와 레시피 찾기
        let userDescriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate<UserModel> { $0.id == userId }
        )
        let recipeDescriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate<RecipeModel> { $0.id == recipeId }
        )
        
        guard let user = try context.fetch(userDescriptor).first,
              let recipe = try context.fetch(recipeDescriptor).first else {
            throw SwiftDataError.entityNotFound
        }
        
        // 이미 북마크된 상태인지 확인
        let bookmarkDescriptor = FetchDescriptor<BookmarkModel>(
            predicate: #Predicate<BookmarkModel> {
                $0.user?.id == userId && $0.recipe?.id == recipeId
            }
        )
        
        let existingBookmarks = try context.fetch(bookmarkDescriptor)
        if !existingBookmarks.isEmpty {
            throw SwiftDataError.bookmarkAlreadyExists
        }
        
        // 새 북마크 생성
        let bookmark = BookmarkModel(user: user, recipe: recipe)
        context.insert(bookmark)
        
        // 레시피 북마크 카운트 증가
        recipe.bookmarkCount += 1
        
        try context.save()
    }
    
    func removeBookmark(userId: String, recipeId: String) throws {
        let descriptor = FetchDescriptor<BookmarkModel>(
            predicate: #Predicate<BookmarkModel> {
                $0.user?.id == userId && $0.recipe?.id == recipeId
            }
        )
        
        let bookmarks = try context.fetch(descriptor)
        
        for bookmark in bookmarks {
            // 레시피 북마크 카운트 감소
            if let recipe = bookmark.recipe {
                recipe.bookmarkCount = max(0, recipe.bookmarkCount - 1)
            }
            context.delete(bookmark)
        }
        
        try context.save()
    }
    
    func isBookmarked(userId: String, recipeId: String) throws -> Bool {
        let descriptor = FetchDescriptor<BookmarkModel>(
            predicate: #Predicate<BookmarkModel> {
                $0.user?.id == userId && $0.recipe?.id == recipeId
            }
        )
        descriptor.fetchLimit = 1
        
        let bookmarks = try context.fetch(descriptor)
        return !bookmarks.isEmpty
    }
    
    func fetchUserBookmarks(userId: String) throws -> [Recipe] {
        let descriptor = FetchDescriptor<BookmarkModel>(
            predicate: #Predicate<BookmarkModel> { $0.user?.id == userId },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        let bookmarks = try context.fetch(descriptor)
        return bookmarks.compactMap { $0.recipe?.toRecipe() }
    }
    
    // MARK: - Search
    
    func searchRecipes(query: String) throws -> [Recipe] {
        let descriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate<RecipeModel> { recipe in
                recipe.title.localizedStandardContains(query) ||
                recipe.recipeDescription.localizedStandardContains(query) ||
                recipe.tagsString.localizedStandardContains(query)
            },
            sortBy: [SortDescriptor(\.rating, order: .reverse)]
        )
        
        let recipes = try context.fetch(descriptor)
        return recipes.map { $0.toRecipe() }
    }
    
    // MARK: - Clear Data
    
    func clearAllData() throws {
        try context.delete(model: UserModel.self)
        try context.delete(model: RecipeModel.self)
        try context.delete(model: BookmarkModel.self)
        try context.save()
    }
}

// MARK: - Errors
enum SwiftDataError: Error, LocalizedError {
    case entityNotFound
    case bookmarkAlreadyExists
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .entityNotFound:
            return "요청한 데이터를 찾을 수 없습니다"
        case .bookmarkAlreadyExists:
            return "이미 북마크된 레시피입니다"
        case .saveFailed:
            return "데이터 저장에 실패했습니다"
        }
    }
}
