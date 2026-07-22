//
//  DSRadius.swift
//  DesignSystem
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

/// Corner radius tokens for consistent rounding across components.
///
/// ```swift
/// RoundedRectangle(cornerRadius: DSRadius.md)
/// ```
public enum DSRadius {
    /// 8pt — subtle rounding, e.g. small cards or chips
    public static let sm: CGFloat = 8

    /// 12pt — default card radius
    public static let md: CGFloat = 12

    /// 16pt — prominent cards or sheets
    public static let lg: CGFloat = 16

    /// 24pt — large containers or modals
    public static let xl: CGFloat = 24

    /// 999pt — fully rounded (pill shape)
    public static let full: CGFloat = 999
}
