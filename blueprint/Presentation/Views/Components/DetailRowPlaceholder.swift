//
//  DetailRowPlaceholder.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import DesignSystem
import SwiftUI

struct DetailRowPlaceholder: View {
    var body: some View {
        HStack(spacing: DSSpacing.md) {
            RoundedRectangle(cornerRadius: DSRadius.sm)
                .frame(width: 36, height: 36)
                .shimmer()

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 60, height: 10)
                    .shimmer()

                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 140, height: 13)
                    .shimmer()
            }

            Spacer()
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
    }
}
