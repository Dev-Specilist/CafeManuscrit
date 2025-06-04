//
//  AppViewModel.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var appState: AppState = .loading
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    
    private let authService = AuthService.shared
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Keychain에서 토큰 확인
            self.isLoggedIn = self.authService.isLoggedIn()
            
            if self.isLoggedIn {
                // Core Data에서 사용자 정보 로드
                Task {
                    self.currentUser = await self.authService.getCurrentUser()
                }
            }
            
            self.appState = .main
        }
    }
    
    func requireLogin() {
        appState = .loginRequired
    }
    
    func login(provider: SSOProvider, idToken: String) async {
        let input = LoginInput(provider: provider, idToken: idToken)
        
        let result = await authService.login(input: input)
        
        await MainActor.run {
            switch result {
            case .success(let output):
                self.currentUser = output.user
                self.isLoggedIn = true
                self.appState = .main
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
                // TODO: 에러 처리 UI
            }
        }
    }
    
    func logout() {
        let success = authService.logout()
        
        if success {
            self.currentUser = nil
            self.isLoggedIn = false
            // 로그아웃 후 메인 화면 유지 (둘러보기 모드)
        }
    }
    
    func refreshTokenIfNeeded() async {
        let result = await authService.refreshToken()
        
        switch result {
        case .success:
            // 토큰 갱신 성공
            break
        case .failure:
            // 토큰 갱신 실패 - 로그아웃 처리
            await MainActor.run {
                logout()
            }
        }
    }
}
