//
//  Color+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 2/8/26.
//

import SwiftUI

public extension Color {
    static func hex(_ hex: String) -> Self {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        let isValidLength = hexSanitized.count == 6 || hexSanitized.count == 8
        
        var rgb: UInt64 = 0
        guard isValidLength, Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return .clear
        }

        let hasAlpha = hexSanitized.count == 8
        let red = Double((rgb & (hasAlpha ? 0x00FF0000 : 0xFF0000)) >> (hasAlpha ? 16 : 16)) / 255.0
        let green = Double((rgb & (hasAlpha ? 0x0000FF00 : 0x00FF00)) >> (hasAlpha ? 8 : 8)) / 255.0
        let blue = Double(rgb & (hasAlpha ? 0x000000FF : 0x0000FF)) / 255.0
        let alpha = hasAlpha ? Double((rgb & 0xFF000000) >> 24) / 255.0 : 1.0

        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}
