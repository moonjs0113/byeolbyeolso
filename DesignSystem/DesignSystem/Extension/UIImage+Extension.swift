//
//  UIImage+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 5/17/26.
//

import UIKit

public extension UIImage {
    convenience init(dAsset: DImageAsset) {
        self.init(dAssetName: dAsset.rawValue)
    }
    
    convenience init(dAssetName: String) {
        guard let image = UIImage(named: dAssetName, in: .designSystem, compatibleWith: nil) else {
            self.init()
            return
        }
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
            return
        }
        if let ciImage = image.ciImage {
            self.init(ciImage: ciImage, scale: image.scale, orientation: image.imageOrientation)
            return
        }
        self.init()
    }
}
