//
//  DetailRowView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI
import DesignSystem

struct DetailRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    var isLink: Bool = false

    var body: some View {
        HStack(spacing: DSSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: DSRadius.sm)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DSTypography.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(DSTypography.subheadline)
                    .foregroundStyle(isLink ? .blue : .primary)
            }

            Spacer()

            if isLink {
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
    }
}
