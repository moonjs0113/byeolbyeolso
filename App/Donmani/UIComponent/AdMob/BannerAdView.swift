//
//  BannerAdView.swift
//  Donmani
//
//  Created by 문종식 on 11/2/25.
//

import GoogleMobileAds
import SwiftUI

struct BannerAdViewWrapper: UIViewRepresentable {
    private let id = "ca-app-pub-3756871454805423/6560832665"
    let adSize: AdSize
    
    init() {
        self.adSize = currentOrientationAnchoredAdaptiveBanner(width: CGFloat.screenWidth)
    }
    
    func makeUIView(context: Context) -> BannerView {
        MobileAds.shared.start()
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = id
        banner.load(Request())
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        
    }
}

struct BannerAdView: View {
    let width: CGFloat
    let cornerRadius: CGFloat
    
    init(width: CGFloat, cornerRadius: CGFloat = 12) {
        self.width = width
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        BannerAdViewWrapper()
            .frame(
                width: width,
                height: currentOrientationAnchoredAdaptiveBanner(
                    width: width
                ).size.height
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
