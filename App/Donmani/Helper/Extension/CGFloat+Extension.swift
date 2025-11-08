//
//  CGFloat+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/7/25.
//

import UIKit
import DesignSystem
import GoogleMobileAds

extension CGFloat {
    public static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    public static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    public static var adScreenWidth: CGFloat {
        screenWidth - (.defaultLayoutPadding * 2)
    }
}
