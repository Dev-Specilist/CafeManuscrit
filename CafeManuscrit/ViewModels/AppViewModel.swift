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
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        // 로그인 상태 확인 (UserDefaults에서 토큰 확인)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let _ = UserDefaults.standard.string(forKey: "accessToken") {
                self.isLoggedIn = true
                self.currentUser = User.dummyUser
            }
            self.appState = .main
        }
    }
    
    func requireLogin() {
        appState = .loginRequired
    }
    
    func login(user: User, token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
        self.currentUser = user
        self.isLoggedIn = true
        self.appState = .main
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        self.currentUser = nil
        self.isLoggedIn = false
    }
}
