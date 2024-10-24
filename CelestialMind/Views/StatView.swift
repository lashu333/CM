//
//  StatView.swift
//  CelestialMind
//
//  Created by Lasha Tavberidze on 24.10.24.
//

import SwiftUI

struct StatView: View {
    let title: String
    let count: Int
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.green.opacity(0.2), radius: 5)
        )
        .onAppear {
            withAnimation(.spring().repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}
