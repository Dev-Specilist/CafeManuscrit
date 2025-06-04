//
//  MainTabView.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 네비게이션 바
            TopNavigationBar(
                searchText: $searchText,
                onSearchTap: {
                    selectedTab = 1
                },
                onProfileTap: {
                    if appViewModel.isLoggedIn {
                        selectedTab = 4
                    } else {
                        appViewModel.requireLogin()
                    }
                }
            )
            .environmentObject(appViewModel)
            
            // 하단 컨텐츠 영역
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        Text("홈")
                    }
                
//                SearchView(searchText: $searchText)
//                    .tag(1)
//                    .tabItem {
//                        Image(systemName: selectedTab == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass")
//                        Text("검색")
//                    }
//                
//                WriteView()
//                    .tag(2)
//                    .tabItem {
//                        Image(systemName: selectedTab == 2 ? "square.and.pencil" : "square.and.pencil")
//                        Text("레시피 작성")
//                    }
//                
//                BookmarkView()
//                    .tag(3)
//                    .tabItem {
//                        Image(systemName: selectedTab == 3 ? "bookmark.fill" : "bookmark")
//                        Text("북마크")
//                    }
//                
//                ProfileView()
//                    .tag(4)
//                    .tabItem {
//                        Image(systemName: selectedTab == 4 ? "person.fill" : "person")
//                        Text("프로필")
//                    }
            }
            .accentColor(.brown)
        }
        .background(Color(.systemBackground))
    }
}


// MARK: - Preview
//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}
