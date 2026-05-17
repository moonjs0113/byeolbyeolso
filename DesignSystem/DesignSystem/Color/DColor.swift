//
//  DColor.swift
//  DesignSystem
//
//  Created by 문종식 on 2/4/25.
//

import SwiftUI

public struct DColor {
    public static let accessoryButton = ColorPalette.Semantic.accessoryButton
    public static let backgroundTop = ColorPalette.Semantic.backgroundTop
    public static let backgroundBottom = ColorPalette.Semantic.backgroundBottom
    
    public static let textGuide = ColorPalette.Semantic.textGuide
    public static let notice = ColorPalette.Semantic.noticeDot
    public static let empty = ColorPalette.Semantic.empty
    
    public static let mainToolTipBackground = ColorPalette.Semantic.mainToolTipBackground
    
    public static let dailyFortuneBackground = ColorPalette.Semantic.dailyFortuneBackground
    
    public var type: DColorType = .deepBlue50
    public var name: String? = nil
    
    public var color: Color {
        let colorName = self.name ?? type.rawValue
        return ColorPalette.color(named: colorName)
    }
    
    public var uiColor: UIColor {
        UIColor(color)
    }
    
    public init(_ type: DColorType) {
        self.type = type
    }
    
    public init(_ name: String) {
        self.name = name
    }
    
}
