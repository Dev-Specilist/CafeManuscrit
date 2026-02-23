import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appViewModel: AppViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Circle()
                    .fill(Color(hex: "E9D7C7"))
                    .frame(width: 72, height: 72)
                    .overlay(
                        Text(initial)
                            .font(.custom("Inter", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "7C4A2D"))
                    )

                Text(displayName)
                    .font(.custom("Inter", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F1A16"))

                Text(appViewModel.isLoggedIn
                    ? L10n.text("profile.logged_in", default: "내 레시피와 북마크를 관리하세요")
                    : L10n.text("profile.logged_out", default: "로그인해 프로필을 완성해 보세요"))
                .font(.custom("Inter", size: 13))
                .foregroundColor(Color(hex: "6A625B"))
                .multilineTextAlignment(.center)

                if appViewModel.isLoggedIn {
                    Button {
                        appViewModel.logout()
                    } label: {
                        Text(L10n.text("profile.logout", default: "로그아웃"))
                            .font(.custom("Inter", size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(Color(hex: "8B5E3C"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal, 20)
                } else {
                    Button {
                        appViewModel.requireLogin()
                    } label: {
                        Text(L10n.text("profile.login", default: "로그인"))
                            .font(.custom("Inter", size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(Color(hex: "8B5E3C"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "FFFFFF"))
            .navigationTitle(L10n.text("profile.title", default: "프로필"))
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var displayName: String {
        appViewModel.currentUser?.name ?? L10n.text("profile.guest", default: "Guest")
    }

    private var initial: String {
        String(displayName.prefix(1)).uppercased()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppViewModel())
    }
}
