//
//  BannerAdView.swift
//  Donmani
//
//  Created by 문종식 on 11/2/25.
//

import GoogleMobileAds
import SwiftUI

struct BannerViewContainer: UIViewRepresentable {
    private let id = "ca-app-pub-3756871454805423/6560832665"
    let adSize: AdSize
    let loadCompleteHandler: () -> Void
    
    init(_ loadCompleteHandler: @escaping () -> Void) {
        self.adSize = currentOrientationAnchoredAdaptiveBanner(width: CGFloat.screenWidth)
        self.loadCompleteHandler = loadCompleteHandler
    }
    
    func makeUIView(context: Context) -> BannerView {
        MobileAds.shared.start()
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = id
        banner.load(Request())
        banner.delegate = context.coordinator
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        
    }
    
    func makeCoordinator() -> BannerCoordinator {
        BannerCoordinator(self)
    }
    
    class BannerCoordinator: NSObject, BannerViewDelegate {
        
        let parent: BannerViewContainer
        
        init(_ parent: BannerViewContainer) {
            self.parent = parent
        }
        
        // MARK: - GADBannerViewDelegate methods
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            parent.loadCompleteHandler()
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
        }
        
        func bannerViewDidRecordClick(_ bannerView: BannerView) {
            print(#function)
        }
        
        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
            print(#function)
        }
        
        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            print(#function)
        }
        
        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
            print(#function)
        }
        
        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            print(#function)
        }
    }
}

struct BannerAdView: View {
    let width: CGFloat
    let cornerRadius: CGFloat
    @State var opacity = 0.4
    
    init(width: CGFloat, cornerRadius: CGFloat = 12) {
        self.width = width
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        BannerViewContainer {
            opacity = 0.0
        }
        .frame(
            width: width,
            height: currentOrientationAnchoredAdaptiveBanner(
                width: width
            ).size.height
        )
        .background(Color.white.opacity(opacity))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
