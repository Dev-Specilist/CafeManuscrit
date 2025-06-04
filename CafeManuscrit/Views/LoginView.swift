//
//  LoginView.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 로고 영역
            VStack(spacing: 20) {
                Spacer()
                
                // 로고
                VStack(spacing: 12) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.brown, Color.orange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    VStack(spacing: 4) {
                        Text("Cafe Manuscrit")
                            .font(.custom("Georgia", size: 32))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text("손글씨로 전하는 커피 이야기")
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            // 하단 로그인 영역
            VStack(spacing: 16) {
                // 안내 문구
                VStack(spacing: 8) {
                    Text("레시피를 공유하려면 로그인이 필요해요")
                        .font(.custom("Georgia", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("나만의 드립 커피 레시피를 세상과 나누어보세요")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 24)
                
                // Apple 로그인 버튼
                AppleSignInButton(isLoading: $isLoading) {
                    signInWithApple()
                }
                
                // Google 로그인 버튼
                GoogleSignInButton(isLoading: $isLoading) {
                    signInWithGoogle()
                }
                
                // 구분선
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.systemGray4))
                    
                    Text("또는")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.systemGray4))
                }
                .padding(.vertical, 8)
                
                // 둘러보기 버튼
                Button(action: {
                    appViewModel.appState = .main
                }) {
                    Text("로그인 없이 둘러보기")
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(.brown)
                        .padding(.vertical, 12)
                }
                
                // 개인정보 처리방침
                HStack(spacing: 4) {
                    Text("로그인 시")
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(.secondary)
                    
                    Button("개인정보 처리방침") {
                        // TODO: 개인정보 처리방침 화면으로 이동
                    }
                    .font(.custom("Georgia", size: 12))
                    .foregroundColor(.brown)
                    
                    Text("에 동의하게 됩니다.")
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
        .background(Color(.systemBackground))
        .disabled(isLoading)
    }
    
    // MARK: - Sign In Methods
    private func signInWithApple() {
        isLoading = true
        
        // TODO: 실제 Apple Sign In 구현
        // 현재는 더미 로그인
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let dummyUser = User(
                id: "apple_\(UUID().uuidString)",
                name: "Apple 사용자",
                email: "apple@example.com",
                profileImageUrl: nil,
                createdAt: Date()
            )
            
            appViewModel.login(user: dummyUser, token: "apple_dummy_token")
            isLoading = false
        }
    }
    
    private func signInWithGoogle() {
        isLoading = true
        
        // TODO: 실제 Google Sign In 구현
        // 현재는 더미 로그인
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let dummyUser = User(
                id: "google_\(UUID().uuidString)",
                name: "Google 사용자",
                email: "google@example.com",
                profileImageUrl: nil,
                createdAt: Date()
            )
            
            appViewModel.login(user: dummyUser, token: "google_dummy_token")
            isLoading = false
        }
    }
}

// MARK: - Apple Sign In Button
struct AppleSignInButton: View {
    @Binding var isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "applelogo")
                        .font(.system(size: 18, weight: .medium))
                }
                
                Text("Apple로 로그인")
                    .font(.custom("Georgia", size: 16))
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isLoading)
    }
}

// MARK: - Google Sign In Button
struct GoogleSignInButton: View {
    @Binding var isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .scaleEffect(0.8)
                } else {
                    // Google 로고 대신 간단한 아이콘 사용
                    Image(systemName: "globe")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                }
                
                Text("Google로 로그인")
                    .font(.custom("Georgia", size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .disabled(isLoading)
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppViewModel())
    }
}
