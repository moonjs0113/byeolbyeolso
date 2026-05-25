//
//  DecorationView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Lottie

extension DecorationView {
    func DecorationGuideBottomSheet() -> some View {
        BottomSheetView(
            addCancelButton: false,
            closeAction: {
                
            }
        ) { dismissSheet in
            VStack(alignment: .center, spacing: .s3) {
                DText(
                    """
                    달이 바뀌어도,
                    내가 꾸민 별통이는 그대로!
                    """
                , style: .h2, weight: .bold, color: ColorPalette.Primary.deepBlue99)
                .lineSpacing(4)
                .padding(.top, -4)
                
                DText("달이 바뀌어 새로 열린 별통이는 언제든 꾸밀 수 있어요", style: .b2, weight: .regular, color: ColorPalette.Primary.deepBlue90)
                
                DImage(DImageAsset.decorationGuide)
                    .resizable()
                    .scaledToFit()
                
                DButton(title: "확인했어요") {
                    dismissSheet {
                        store.send(.touchGuideBottomSheetButton)
                    }
                }
                .padding(.top, .defaultLayoutPadding / 2)
                .padding(.bottom, -.defaultLayoutPadding)
            }
        }
    }
    
    func DecorationFullBottomSheet() -> some View {
        BottomSheetView(
            isActiveClose: false,
            addCancelButton: false,
            closeAction: {
                
            }
        ) { dismissSheet in
            VStack(alignment: .center, spacing: .s3) {
                DText("축하해요! 🎉", style: .h1, weight: .bold, color: ColorPalette.Primary.deepBlue99)
                .lineSpacing(4)
                .padding(.top, -4)
                
                DText("12개 선물을 모두 모아\n토비의 우주바캉스🏝️를 받았어요!", style: .b2, weight: .regular, color: ColorPalette.Primary.deepBlue99)
                    .multilineTextAlignment(.center)
                    .padding(.top, -10)
                
                LottieView(animation: store.lottieFinalAnimation)
                    .playing(loopMode: .loop)
                    .frame(height: .screenWidth * (12/25))
                
                DButton(title: "히든 아이템 받기") {
                    dismissSheet {
                        store.send(.touchFinalBottomSheetButton)
                    }
                }
                .padding(.top, .defaultLayoutPadding / 2)
                .padding(.bottom, -.defaultLayoutPadding)
            }
        }
    }
}
