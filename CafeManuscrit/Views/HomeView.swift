//
//  HomeView.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import SwiftUI

struct HomeView: View {
    @State private var featuredRecipes: [Recipe] = []
    @State private var recentRecipes: [Recipe] = []
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                HomeHeaderSection()
                
                if !featuredRecipes.isEmpty {
                    RecipeSectionView(
                        title: "✨ 오늘의 추천 레시피",
                        recipes: featuredRecipes,
                        style: .featured
                    )
                }
                
                RecipeSectionView(
                    title: "📝 최신 레시피",
                    recipes: recentRecipes,
                    style: .recent
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .background(Color(.systemBackground))
        .onAppear {
            loadRecipes()
        }
    }
    
    private func loadRecipes() {
        featuredRecipes = Recipe.dummyFeaturedRecipes
        recentRecipes = Recipe.dummyRecentRecipes
    }
}

// MARK: - Home Header Section
struct HomeHeaderSection: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("안녕하세요!")
                        .font(.custom("Georgia", size: 24))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("오늘은 어떤 커피를 드려보실까요?")
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.brown, Color.orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.brown.opacity(0.1), Color.orange.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
        }
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
