//
//  SkeletonCardView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import DesignSystem
import SwiftUI

struct SkeletonCardView: View {
    var body: some View {
        HStack(spacing: DSSpacing.md) {
            RoundedRectangle(cornerRadius: DSRadius.sm)
                .frame(width: 48, height: 48)
                .shimmer()

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                RoundedRectangle(cornerRadius: DSRadius.sm)
                    .frame(height: 16)
                    .frame(maxWidth: 180)
                    .shimmer()

                RoundedRectangle(cornerRadius: DSRadius.sm)
                    .frame(height: 12)
                    .frame(maxWidth: 120)
                    .shimmer()
            }

            Spacer()
        }
        .padding(DSSpacing.md)
        .background(.background, in: RoundedRectangle(cornerRadius: DSRadius.md))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}
