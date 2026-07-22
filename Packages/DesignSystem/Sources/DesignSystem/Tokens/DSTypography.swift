//
//  DSTypography.swift
//  DesignSystem
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

/// Typography tokens that map to Apple's Dynamic Type system.
///
/// All values scale automatically with the user's preferred text size,
/// ensuring accessibility compliance without extra work.
///
/// ```swift
/// Text("Hello")
///     .font(DSTypography.headline)
/// ```
public enum DSTypography {
    /// The largest title style — use for screen heroes
    public static let largeTitle: Font = .largeTitle

    /// Primary title — use for screen titles
    public static let title: Font = .title

    /// Secondary title
    public static let title2: Font = .title2

    /// Tertiary title
    public static let title3: Font = .title3

    /// Emphasized body text — use for list item names
    public static let headline: Font = .headline

    /// Default reading text
    public static let body: Font = .body

    /// Slightly smaller than body — use for supplementary info
    public static let callout: Font = .callout

    /// Secondary label text — use for subtitles
    public static let subheadline: Font = .subheadline

    /// Small text — use for metadata
    public static let footnote: Font = .footnote

    /// Smallest text — use for tags or timestamps
    public static let caption: Font = .caption
}
