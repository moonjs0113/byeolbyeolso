//
//  RecordCategory+UI.swift
//  Donmani
//
//  Created by 문종식 on 6/8/26.
//

import SwiftUI
import DesignSystem
import Domain

extension RecordCategory {
    var color: Color {
        ColorPalette.color(named: assetName)
    }
    
    var image: Image {
        DImage(assetName: assetName)
    }
    
    var smallImage: Image {
        DImage(assetName: "\(assetName)_small")
    }
}
