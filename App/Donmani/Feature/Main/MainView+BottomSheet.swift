//
//  MainView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

import SwiftUI
import Networking
import DesignSystem
import Domain

extension MainView {
    func AppStoreView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: { }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                DText("최신 버전으로 업데이트 부탁드려요!", style: .h2, weight: .bold, color: ColorPalette.Neutral.gray95)
                DText("더 나은 서비스 사용 환경을 위해 최신 버전의 앱으로 업데이트를 부탁드립니다.", style: .b1, weight: .regular, color: ColorPalette.Neutral.gray95)
                
                if let url = URL(string: DURL.appStore.urlString) {
                    Link(destination: url) {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(ColorPalette.Neutral.gray95)
                            .frame(height: 58)
                            DText("업데이트 하기", style: .h3, weight: .bold, color: ColorPalette.Primary.deepBlue20)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    func NewStarBottleView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: {
                UINavigationController.isBlockSwipe = false
            }
        ) { dismissSheet in
            VStack(alignment: .center, spacing: .s3) {
                VStack(spacing: 8) {
                    DText("\(store.day.month)월 별통이가 열렸어요!", style: .h1, weight: .bold, color: ColorPalette.Neutral.gray99)
                    
                    DText("매 월 1일에 새로운 별통이가 열려요", style: .b1, weight: .regular, color: ColorPalette.Neutral.gray95)
                }
                
                ZStack {
                    DImage(DImageAsset.newStarBottleBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    
                    DImage(DImageAsset.newStarBottle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 167)
                }
                
                Button {
                    dismissSheet {
                        store.send(.dismissNewStarBottleView)
                    }
                } label: {
                    HStack(spacing: 4) {
                        DText("지난 달 별통이 보러가기", style: .b1, weight: .regular, color: ColorPalette.Primary.deepBlue90)
                        
                        DImage(DImageAsset.arrowRight)
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(ColorPalette.Primary.deepBlue90)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s5, height: .s5)
                    }
                }
                
                DButton(title: "확인했어요") {
                    dismissSheet {
                        store.send(.dismissNewStarBottleView)
                    }
                }
            }
        }
    }
    
    func OnboardingEndView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: { }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                DText("앗! 어제 오늘 소비 모두 기록 했어요\n내일 또 기록 할 수 있어요!", style: .h2, weight: .bold, color: ColorPalette.Primary.deepBlue99)
                    .lineSpacing(.s5/2)
                VStack(spacing: 0) {
                    DImage(DImageAsset.onboardingEnd)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    DButton(title: "확인했어요") {
                        dismissSheet {
                            store.send(.dismissAlreadyWrite)
                        }
                    }
                }
            }
            .padding(.top, -10)
        }
    }
    
    func TodayFortuneView(isNotificationEnabled: Bool?) -> some View {
        BottomSheetView(
            addCancelButton: false,
            closeAction: { }
        ) { dismissSheet in
            VStack(spacing: .s3) {
                VStack(spacing: 8) {
                    DText(
                        "저 왔어요! 오늘의 운세 🍀",
                        style: .h1,
                        weight: .bold,
                        color: ColorPalette.Primary.deepBlue99
                    )
                    .lineSpacing(.s5/2)
                    DText(
                        "오늘, 무슨 일이 생길까요?\n토비 요정이 알려주는 운세 확인해보세요!",
                        style: .b1,
                        weight: .regular,
                        color: ColorPalette.Neutral.gray95
                    )
                    .lineSpacing(.s5/2)
                    .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 0) {
                    DImage(DImageAsset.todayFortune)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    VStack(spacing: 8) {
                        DButton(title: "오늘의 내 행운은?") {
                            store.send(.touchTodayFortuneConfirm)
                        }

                        if !(isNotificationEnabled ?? false) {
                            Button {
                                store.send(.touchEnableNotificationButton)
                            } label: {
                                ZStack {
                                    RoundedRectangle(
                                        cornerRadius: .s5,
                                        style: .continuous
                                    )
                                    .fill(ColorPalette.Primary.deepBlue50)
                                    DText("알림 켜기",
                                          style: .h3,
                                          weight: .bold,
                                          color: .white
                                    )
                                }
                            }
                            .frame(height: 58)
                        }
                    }
                }
            }
        }
    }
}
