//
//  LoadingView.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Image(systemName: "drop.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.brown, Color.orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(), value: isAnimating)
            
            Text("Cafe Manuscrit")
                .font(.custom("Georgia", size: 24))
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
