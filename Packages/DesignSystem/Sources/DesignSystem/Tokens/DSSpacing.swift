//
//  DSSpacing.swift
//  DesignSystem
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

/// Spacing tokens used for margins, paddings, and gaps throughout the app.
///
/// Use these values instead of raw numbers to keep layouts consistent
/// and easy to update globally.
///
/// ```swift
/// VStack(spacing: DSSpacing.sm) { ... }
/// .padding(DSSpacing.md)
/// ```
public enum DSSpacing {
    /// 4pt — tight spacing between closely related elements
    public static let xxs: CGFloat = 4

    /// 8pt — small spacing, e.g. icon + label
    public static let xs: CGFloat = 8

    /// 12pt — compact spacing inside components
    public static let sm: CGFloat = 12

    /// 16pt — default spacing for most layouts
    public static let md: CGFloat = 16

    /// 24pt — section spacing
    public static let lg: CGFloat = 24

    /// 32pt — large gaps between major sections
    public static let xl: CGFloat = 32

    /// 48pt — screen-level padding or hero spacing
    public static let xxl: CGFloat = 48
}
