//
//  DImage.swift
//  DesignSystem
//
//  Created by 문종식 on 2/4/25.
//

import SwiftUI

public typealias DImage = Image

public extension Image {
    init(_ asset: DImageAsset) {
        self = Image(asset.rawValue, bundle: .designSystem)
    }
    
    init(assetName: String) {
        self = Image(assetName, bundle: .designSystem)
    }
}
