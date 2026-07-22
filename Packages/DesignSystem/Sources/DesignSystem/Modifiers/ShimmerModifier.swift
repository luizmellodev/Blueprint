//
//  ShimmerModifier.swift
//  DesignSystem
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

private struct ShimmerModifier: ViewModifier {
    let style: SkeletonStyle
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    stops: [
                        .init(color: style.baseColor, location: phase - 0.3),
                        .init(color: style.highlightColor, location: phase),
                        .init(color: style.baseColor, location: phase + 0.3)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            .onAppear {
                withAnimation(.linear(duration: style.animationDuration).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

public extension View {
    func shimmer(style: SkeletonStyle = .default) -> some View {
        modifier(ShimmerModifier(style: style))
    }
}
