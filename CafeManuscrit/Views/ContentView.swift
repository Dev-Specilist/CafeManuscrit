//
//  ContentView.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/1/25.
//
import SwiftUI

struct ContentView: View{
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var recipeRepository = RecipeRepository()
    
    var body: some View {
        Group {
            switch appViewModel.appState {
            case .loading:
                LoadingView()
            case .main:
                MainTabView()
                    .environmentObject(appViewModel)
                    .environmentObject(recipeRepository)
            case .loginRequired:
                LoginView()
                    .environmentObject(appViewModel)
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
