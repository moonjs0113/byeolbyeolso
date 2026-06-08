//
//  DText.swift
//  DesignSystem
//
//  Created by 문종식 on 4/5/25.
//

import SwiftUI

public typealias DText = Text

public extension Text {
    init(
        _ text: String,
        style: DFontStyle,
        weight: DFontWeight,
        color: Color
    ) {
        self = Text(text)
            .font(DFont.font(style, weight: weight))
            .foregroundColor(color)
    }
}
