//
//  DSColor.swift
//  DesignSystem
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque usamos UIColor(dynamicProvider:) em vez de Color do asset catalog
// (Swift Package não tem acesso direto a .xcassets do app target)

import SwiftUI
import UIKit

public enum DSColor {
    public static let tourism       = Color(light: Color(hex: 0xFF9500), dark: Color(hex: 0xFFB340))
    public static let catering      = Color(light: Color(hex: 0xFF3B30), dark: Color(hex: 0xFF453A))
    public static let entertainment = Color(light: Color(hex: 0xAF52DE), dark: Color(hex: 0xBF5AF2))
    public static let leisure       = Color(light: Color(hex: 0x34C759), dark: Color(hex: 0x30D158))
    public static let accommodation = Color(light: Color(hex: 0x007AFF), dark: Color(hex: 0x0A84FF))
    public static let unknown       = Color(light: Color(hex: 0x8E8E93), dark: Color(hex: 0x98989D))
}

// MARK: - Color helpers

public extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor { traits in
            UIColor(traits.userInterfaceStyle == .dark ? dark : light)
        })
    }

    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
