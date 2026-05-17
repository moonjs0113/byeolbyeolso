//
//  DText.swift
//  DesignSystem
//
//  Created by 문종식 on 4/5/25.
//

import SwiftUI

/// DesignSystem text factory with explicit style.
public func DText(
    _ text: String,
    style: DFontStyle,
    weight: DFontWeight,
    color: Color
) -> Text {
    Text(text)
        .font(DFont.font(style, weight: weight))
        .foregroundColor(color)
}
