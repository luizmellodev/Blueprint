//
//  SkeletonStyle.swift
//  DesignSystem
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

public struct SkeletonStyle: Sendable {
    let baseColor: Color
    let highlightColor: Color
    let cornerRadius: CGFloat
    let animationDuration: Double

    public init(
        baseColor: Color = Color(.systemGray5),
        highlightColor: Color = Color(.systemGray4),
        cornerRadius: CGFloat = 8,
        animationDuration: Double = 1.5
    ) {
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.cornerRadius = cornerRadius
        self.animationDuration = animationDuration
    }

    public static let `default` = SkeletonStyle()
    public static let rounded = SkeletonStyle(cornerRadius: 12)
    public static let circular = SkeletonStyle(cornerRadius: 999)
}
