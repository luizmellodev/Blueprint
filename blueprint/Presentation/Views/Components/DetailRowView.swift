//
//  DetailRowView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import DesignSystem
import SwiftUI

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
            .accessibilityHidden(true)

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
                    .accessibilityHidden(true)
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
        .accessibilityAddTraits(isLink ? [.isLink] : [])
    }
}

#Preview {
    VStack(spacing: 0) {
        DetailRowView(
            icon: "mappin.circle.fill", iconColor: .red,
            title: "Address", value: "Parque da Independência, São Paulo"
        )
        Divider().padding(.leading, 56)
        DetailRowView(icon: "clock.fill", iconColor: .orange, title: "Opening Hours", value: "Tu-Su 09:00-17:00")
        Divider().padding(.leading, 56)
        DetailRowView(
            icon: "safari.fill", iconColor: .blue,
            title: "Website", value: "museuipiranga.org.br", isLink: true
        )
    }
    .padding(.horizontal)
}
