//
//  DNavigationBarButton.swift
//  DesignSystem
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI

public enum DNavigationBarButtonType {
    case image(DImageAsset)
    case text(String)
}

public struct DNavigationBarButton: View {
    private let type: DNavigationBarButtonType
    private let action: (() -> Void)
    
    public init(
        _ type: DNavigationBarButtonType,
        _ action: @escaping () -> Void
    ) {
        self.type = type
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            switch type {
            case let .image(icon):
                DImage(icon).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3)
            case let .text(text):
                DText(text, style: .b1, weight: .semibold, color: ColorPalette.Primary.deepBlue99)
                    .frame(width: .s3)
            }
        }
        .frame(width: .s3, height: .s3)
    }
}
