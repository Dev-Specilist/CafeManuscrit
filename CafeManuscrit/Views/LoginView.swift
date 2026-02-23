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
                        Text(L10n.text("login.brand.title", default: "Cafe Manuscrit"))
                            .font(.custom("Georgia", size: 32))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text(L10n.text("login.brand.subtitle", default: "Coffee stories written by hand"))
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
                    Text(L10n.text("login.auth.title", default: "Sign in to share your recipes"))
                        .font(.custom("Georgia", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(L10n.text("login.auth.subtitle", default: "Share your own pour-over recipes with the world."))
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
                    
                    Text(L10n.text("login.auth.or", default: "or"))
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
                    Text(L10n.text("login.auth.continue_without", default: "Continue without login"))
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(.brown)
                        .padding(.vertical, 12)
                }
                
                // 개인정보 처리방침
                HStack(spacing: 4) {
                    Text(L10n.text("login.legal.privacy.prefix", default: "By signing in, you agree to"))
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(.secondary)
                    
                    Button(L10n.text("login.legal.privacy.policy", default: "Privacy Policy")) {
                        // TODO: Navigate to privacy policy
                    }
                    .font(.custom("Georgia", size: 12))
                    .foregroundColor(.brown)
                    
                    Text(L10n.text("login.legal.privacy.suffix", default: "."))
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
        
        // TODO: Implement Apple Sign In
        // Temporary mock login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let dummyUser = User(
                id: "apple_\(UUID().uuidString)",
                name: ContentText.User.appleMockName,
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
        
        // TODO: Implement Google Sign In
        // Temporary mock login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let dummyUser = User(
                id: "google_\(UUID().uuidString)",
                name: ContentText.User.googleMockName,
                email: "google@example.com",
                profileImageUrl: nil,
                createdAt: Date()
            )
            
            appViewModel.login(user: dummyUser, token: "google_dummy_token")
            isLoading = false
        }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppViewModel())
    }
}
