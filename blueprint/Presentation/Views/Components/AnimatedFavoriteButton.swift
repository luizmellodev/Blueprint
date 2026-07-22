//
//  AnimatedFavoriteButton.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

struct AnimatedFavoriteButton: View {
    let isLiked: Bool
    let onTap: () -> Void

    @State private var bouncing = false
    @State private var particles: [FavoriteParticle] = []

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .offset(x: particle.offsetX, y: particle.offsetY)
                    .opacity(particle.opacity)
            }
            .accessibilityHidden(true)

            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(isLiked ? .red : .secondary)
                .scaleEffect(bouncing ? 1.4 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.4), value: bouncing)
        }
        .frame(width: 56, height: 56)
        .onTapGesture {
            onTap()
            guard !isLiked else { return }
            triggerAnimation()
        }
        .onChange(of: isLiked) { _, newValue in
            if newValue { triggerAnimation() }
        }
        .accessibilityLabel(isLiked ? "Remove from favorites" : "Add to favorites")
        .accessibilityValue(isLiked ? "Saved" : "Not saved")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction {
            onTap()
        }
    }

    private func triggerAnimation() {
        bouncing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { bouncing = false }
        emitParticles()
    }

    private func emitParticles() {
        let colors: [Color] = [.red, .pink, .orange, .yellow, .purple]
        let count = 12
        particles = (0..<count).map { idx in
            let angle = Double(idx) / Double(count) * 2 * .pi
            return FavoriteParticle(
                color: colors[idx % colors.count],
                size: CGFloat.random(in: 4...8),
                targetX: cos(angle) * CGFloat.random(in: 28...44),
                targetY: sin(angle) * CGFloat.random(in: 28...44)
            )
        }

        withAnimation(.easeOut(duration: 0.55)) {
            for idx in particles.indices {
                particles[idx].offsetX = particles[idx].targetX
                particles[idx].offsetY = particles[idx].targetY
                particles[idx].opacity = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { particles = [] }
    }
}

private struct FavoriteParticle: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    let targetX: CGFloat
    let targetY: CGFloat
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0
    var opacity: Double = 1
}
