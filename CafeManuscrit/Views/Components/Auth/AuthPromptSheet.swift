import SwiftUI

struct AuthPromptSheet: View {
    let title: String
    let message: String
    let onLogin: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "D6CEC6"))
                .frame(width: 40, height: 6)
                .padding(.top, 6)

            Text(title)
                .font(.custom("Inter", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "1F1A16"))

            Text(message)
                .font(.custom("Inter", size: 13))
                .foregroundColor(Color(hex: "6A625B"))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 6)

            Button {
                dismiss()
                onLogin()
            } label: {
                Text(L10n.text("auth.prompt.login", default: "로그인하기"))
                    .font(.custom("Inter", size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(hex: "8B5E3C"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button {
                dismiss()
            } label: {
                Text(L10n.text("auth.prompt.later", default: "나중에"))
                    .font(.custom("Inter", size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "6A625B"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "D8D2CC"), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .presentationDetents([.height(270)])
    }
}
