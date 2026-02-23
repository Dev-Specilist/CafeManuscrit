//
//  TopNavigationBar.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/1/25.
//
import SwiftUI

struct TopNavigationBar: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Binding var searchText: String
    let onSearchTap: () -> Void
    let onProfileTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // 좌측: 로고 (비율 1)
            LogoSection()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 중앙: 검색창 (비율 3)
            SearchSection(searchText: $searchText, onTap: onSearchTap)
                .frame(maxWidth: .infinity * 3)
            
            // 우측: 유저 아이콘 (비율 1)
            ProfileSection(
                isLoggedIn: appViewModel.isLoggedIn,
                onTap: onProfileTap
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Logo Section
struct LogoSection: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "drop.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.brown, Color.orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            VStack(alignment: .leading, spacing: -2) {
                Text("Cafe")
                    .font(.custom("Georgia", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Manuscrit")
                    .font(.custom("Georgia", size: 10))
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}

// MARK: - Search Section
struct SearchSection: View {
    @Binding var searchText: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16))
                
                Text(searchText.isEmpty ? L10n.text("common.search.placeholder", default: "Search recipes...") : searchText)
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(searchText.isEmpty ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Profile Section
struct ProfileSection: View {
    let isLoggedIn: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Group {
                if isLoggedIn {
                    AsyncImage(url: URL(string: "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.brown.opacity(0.7), Color.orange.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                Text("U")
                                    .font(.custom("Georgia", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                } else {
                    Circle()
                        .fill(Color(.systemBackground))
                        .overlay(
                            Circle()
                                .stroke(Color(.systemGray4), lineWidth: 1.5)
                        )
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "person")
                                .foregroundColor(.secondary)
                                .font(.system(size: 14))
                        )
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
