//
//  ActionButton.swift
//  CelestialMind
//
//  Created by Lasha Tavberidze on 24.10.24.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(color.opacity(isHovered ? 0.9 : 0.7))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .shadow(color: color.opacity(0.3), radius: isHovered ? 8 : 4)
        }
        .onHover { hovering in
            withAnimation(.spring()) {
                isHovered = hovering
            }
        }
    }
}
