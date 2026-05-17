//
//  DText.swift
//  DesignSystem
//
//  Created by 문종식 on 4/5/25.
//

import SwiftUI

/// DesignSystem text factory.
///
/// Returns `Text` directly so callers can treat `DText(...)` as `Text`.
public func DText(_ text: String) -> Text {
    Text(text)
}

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

public func DText(
    _ text: String,
    style: DFontStyle,
    weight: DFontWeight,
    color: DColorType
) -> Text {
    DText(
        text,
        style: style,
        weight: weight,
        color: DColor(color).color
    )
}

public extension Text {
    func style(
        _ style: DFontStyle,
        _ weight: DFontWeight,
        _ color: Color
    ) -> Text {
        self
            .font(DFont.font(style, weight: weight))
            .foregroundColor(color)
    }
    
    func style(
        _ style: DFontStyle,
        _ weight: DFontWeight,
        _ color: DColorType
    ) -> Text {
        self
            .font(DFont.font(style, weight: weight))
            .foregroundColor(DColor(color).color)
    }
}
