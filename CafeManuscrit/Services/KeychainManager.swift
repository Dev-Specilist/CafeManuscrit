//
//  KeychainManager.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/4/25.
//

import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    // MARK: - Token Management
    
    func saveAccessToken(_ token: String) -> Bool {
        return save(token, for: .accessToken)
    }
    
    nonisolated func getAccessToken() -> String? {
        return get(.accessToken)
    }
    
    func saveRefreshToken(_ token: String) -> Bool {
        return save(token, for: .refreshToken)
    }
    
    func getRefreshToken() -> String? {
        return get(.refreshToken)
    }
    
    func saveUserEmail(_ email: String) -> Bool {
        return save(email, for: .userEmail)
    }
    
    func getUserEmail() -> String? {
        return get(.userEmail)
    }
    
    func clearAllTokens() {
        delete(.accessToken)
        delete(.refreshToken)
        delete(.userEmail)
    }
    
    // MARK: - Private Methods
    
    private func save(_ value: String, for key: KeychainKey) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        // 기존 값이 있으면 업데이트, 없으면 추가
        delete(key) // 기존 값 삭제
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: "CafeManuscrit",
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private func get(_ key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: "CafeManuscrit",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    private func delete(_ key: KeychainKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: "CafeManuscrit"
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Keychain Keys
extension KeychainManager {
    enum KeychainKey: String {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case userEmail = "user_email"
    }
}
