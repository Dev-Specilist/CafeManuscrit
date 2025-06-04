//
//  AuthService.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/4/25.
//
import Foundation

@MainActor
class AuthService: ObservableObject {
    static let shared = AuthService()
    
    nonisolated private let keychainManager = KeychainManager.shared
    private let dataManager = SwiftDataManager.shared
    
    private init() {}
    
    // MARK: - Public Methods
    
    func login(input: LoginInput) async -> Result<LoginOutput, AuthError> {
        do {
            // TODO: 실제 백엔드 API 호출
            let response = try await performLogin(input)
            
            // Keychain에 토큰 저장
            let tokensSaved = saveTokensToKeychain(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                email: response.user.email
            )
            
            if !tokensSaved {
                return .failure(.keychainError)
            }
            
            // SwiftData에 사용자 정보 저장
            try dataManager.saveUser(response.user)
            
            return .success(response)
            
        } catch {
            return .failure(.networkError)
        }
    }
    
    nonisolated func refreshToken() async -> Result<String, AuthError> {
        guard let refreshToken = keychainManager.getRefreshToken() else {
            return .failure(.noRefreshToken)
        }
        
        do {
            // TODO: 실제 토큰 갱신 API 호출
            let newAccessToken = try await performTokenRefresh(refreshToken)
            
            // 새 액세스 토큰 저장
            if !keychainManager.saveAccessToken(newAccessToken) {
                return .failure(.keychainError)
            }
            
            return .success(newAccessToken)
            
        } catch {
            return .failure(.tokenRefreshFailed)
        }
    }
    
    func logout() -> Bool {
        // Keychain에서 모든 토큰 삭제
        keychainManager.clearAllTokens()
        
        // SwiftData에서 사용자 데이터 삭제 (선택적)
        do {
            try dataManager.clearAllData()
            return true
        } catch {
            print("Clear data error: \(error)")
            return false
        }
    }
    
    nonisolated func isLoggedIn() -> Bool {
        return keychainManager.getAccessToken() != nil
    }
    
    func getCurrentUser() async -> User? {
        do {
            return try dataManager.getCurrentUser()
        } catch {
            print("Get current user error: \(error)")
            return nil
        }
    }
    
    // MARK: - Recipe Management
    
    func saveRecipe(_ recipe: Recipe) async -> Result<Void, AuthError> {
        do {
            try dataManager.saveRecipe(recipe)
            return .success(())
        } catch {
            return .failure(.unknownError)
        }
    }
    
    func getUserRecipes(userId: String) async -> [Recipe] {
        do {
            return try dataManager.fetchUserRecipes(userId: userId)
        } catch {
            print("Fetch user recipes error: \(error)")
            return []
        }
    }
    
    func getFeaturedRecipes() async -> [Recipe] {
        do {
            return try dataManager.fetchFeaturedRecipes()
        } catch {
            print("Fetch featured recipes error: \(error)")
            return Recipe.dummyFeaturedRecipes // 폴백
        }
    }
    
    func getAllRecipes() async -> [Recipe] {
        do {
            return try dataManager.fetchAllRecipes()
        } catch {
            print("Fetch all recipes error: \(error)")
            return Recipe.dummyRecentRecipes // 폴백
        }
    }
    
    // MARK: - Bookmark Management
    
    func toggleBookmark(userId: String, recipeId: String) async -> Result<Bool, AuthError> {
        do {
            let isCurrentlyBookmarked = try dataManager.isBookmarked(userId: userId, recipeId: recipeId)
            
            if isCurrentlyBookmarked {
                try dataManager.removeBookmark(userId: userId, recipeId: recipeId)
                return .success(false)
            } else {
                try dataManager.addBookmark(userId: userId, recipeId: recipeId)
                return .success(true)
            }
        } catch {
            return .failure(.unknownError)
        }
    }
    
    func getUserBookmarks(userId: String) async -> [Recipe] {
        do {
            return try dataManager.fetchUserBookmarks(userId: userId)
        } catch {
            print("Fetch user bookmarks error: \(error)")
            return []
        }
    }
    
    func searchRecipes(query: String) async -> [Recipe] {
        do {
            return try dataManager.searchRecipes(query: query)
        } catch {
            print("Search recipes error: \(error)")
            return []
        }
    }
    
    // MARK: - Private Methods
    
    nonisolated private func saveTokensToKeychain(accessToken: String, refreshToken: String, email: String) -> Bool {
        let accessTokenSaved = keychainManager.saveAccessToken(accessToken)
        let refreshTokenSaved = keychainManager.saveRefreshToken(refreshToken)
        let emailSaved = keychainManager.saveUserEmail(email)
        
        return accessTokenSaved && refreshTokenSaved && emailSaved
    }
    
    nonisolated private func performLogin(_ input: LoginInput) async throws -> LoginOutput {
        // TODO: 실제 백엔드 API 호출 구현
        // 현재는 더미 데이터 반환
        
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5초 대기
        
        let user = User(
            id: "\(input.provider.rawValue)_\(UUID().uuidString)",
            name: "\(input.provider.displayName) 사용자",
            email: "\(input.provider.rawValue)@example.com",
            profileImageUrl: nil,
            createdAt: Date()
        )
        
        return LoginOutput(
            user: user,
            accessToken: "access_token_\(UUID().uuidString)",
            refreshToken: "refresh_token_\(UUID().uuidString)"
        )
    }
    
    nonisolated private func performTokenRefresh(_ refreshToken: String) async throws -> String {
        // TODO: 실제 토큰 갱신 API 호출 구현
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
        return "new_access_token_\(UUID().uuidString)"
    }
}
