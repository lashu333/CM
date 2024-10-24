//
//  CelestialBackgroundView.swift
//  CelestialMind
//
//  Created by Lasha Tavberidze on 24.10.24.
//

import SwiftUI

struct CelestialBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.08, blue: 0.25), // #0D1441
                    Color(red: 0.14, green: 0.07, blue: 0.36)  // #24115D
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Adding glowing stars using small circles
            ForEach(0..<15) { _ in
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: CGFloat.random(in: 2...5), height: CGFloat.random(in: 2...5))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .blur(radius: 1.5)
            }
        }
    }
}

#Preview {
    CelestialBackgroundView()
}
