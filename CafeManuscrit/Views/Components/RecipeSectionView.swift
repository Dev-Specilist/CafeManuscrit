//
//  RecipeSectionView.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import SwiftUI

struct RecipeSectionView: View {
    let title: String
    let recipes: [Recipe]
    let style: RecipeCardStyle
    
    enum RecipeCardStyle {
        case featured
        case recent
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Georgia", size: 20))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
            
            if style == .featured {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(recipes) { recipe in
                            FeaturedRecipeCard(recipe: recipe)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(recipes) { recipe in
                        RecentRecipeCard(recipe: recipe)
                    }
                }
            }
        }
    }
}

// MARK: - Featured Recipe Card
struct FeaturedRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        Button(action: {
            // TODO: 레시피 상세 화면으로 이동
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // 레시피 이미지
                AsyncImage(url: URL(string: recipe.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .overlay(
                            VStack {
                                Image(systemName: "cup.and.saucer")
                                    .font(.system(size: 24))
                                    .foregroundColor(.secondary)
                                
                                Text(recipe.brewMethod.displayName)
                                    .font(.custom("Georgia", size: 12))
                                    .foregroundColor(.secondary)
                            }
                        )
                }
                .frame(width: 200, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // 레시피 정보
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.custom("Georgia", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(String(format: L10n.text("common.recipe.by_author", default: "by %@"), recipe.author.name))
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(.secondary)
                    
                    HStack {
                        // 평점
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                            
                            Text(String(format: "%.1f", recipe.rating))
                                .font(.custom("Georgia", size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // 추출 방법 태그
                        Text(recipe.brewMethod.displayName)
                            .font(.custom("Georgia", size: 10))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.brown.opacity(0.1))
                            .foregroundColor(.brown)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 200)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Recent Recipe Card
struct RecentRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        Button(action: {
                // TODO: Navigate to recipe details
        }) {
            HStack(spacing: 12) {
                // 레시피 이미지
                AsyncImage(url: URL(string: recipe.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .overlay(
                            VStack {
                                Image(systemName: recipe.brewMethod.icon)
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                            }
                        )
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // 레시피 정보
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.custom("Georgia", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(recipe.description)
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    HStack {
                        Text(String(format: L10n.text("common.recipe.by_author", default: "by %@"), recipe.author.name))
                            .font(.custom("Georgia", size: 11))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        // 평점
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                            
                            Text(String(format: "%.1f", recipe.rating))
                                .font(.custom("Georgia", size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // 추출 방법 태그
                        Text(recipe.brewMethod.displayName)
                            .font(.custom("Georgia", size: 10))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.brown.opacity(0.1))
                            .foregroundColor(.brown)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                        // 북마크 아이콘
                        Image(systemName: "bookmark")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(12)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color(.systemGray4).opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
