//
//  ContentView.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/1/25.
//
import SwiftUI

struct ContentView: View{
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        Group {
            switch appViewModel.appState {
            case .loading:
                LoadingView()
            case .main:
                MainTabView()
                    .environmentObject(appViewModel)
            case .loginRequired:
                LoginView()
                    .environmentObject(appViewModel)
            }
        }
        .onAppear {
            appViewModel.checkAuthStatus()
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
