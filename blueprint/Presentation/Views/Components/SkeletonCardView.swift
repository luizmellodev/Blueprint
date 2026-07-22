//
//  SkeletonCardView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI
import DesignSystem

struct SkeletonCardView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        HStack(spacing: DSSpacing.md) {
            RoundedRectangle(cornerRadius: DSRadius.sm)
                .frame(width: 48, height: 48)
                .shimmer(phase: phase)

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                RoundedRectangle(cornerRadius: DSRadius.sm)
                    .frame(height: 16)
                    .frame(maxWidth: 180)
                    .shimmer(phase: phase)

                RoundedRectangle(cornerRadius: DSRadius.sm)
                    .frame(height: 12)
                    .frame(maxWidth: 120)
                    .shimmer(phase: phase)
            }

            Spacer()
        }
        .padding(DSSpacing.md)
        .background(.background, in: RoundedRectangle(cornerRadius: DSRadius.md))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .onAppear {
            withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

private extension View {
    func shimmer(phase: CGFloat) -> some View {
        self.overlay(
            LinearGradient(
                stops: [
                    .init(color: Color(.systemGray5), location: phase - 0.3),
                    .init(color: Color(.systemGray4), location: phase),
                    .init(color: Color(.systemGray5), location: phase + 0.3),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
    }
}
