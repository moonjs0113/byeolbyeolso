//
//  ContentView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import UIKit
import ComposableArchitecture
import DesignSystem
import Domain

struct MainView: View {
    @EnvironmentObject private var toastManager: ToastManager
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var store: StoreOf<MainStore>
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: .s3) {
                    DNavigationBar(
                        leading: {
                            DNavigationBarButton(.image(.setting)) {
                                GA.Click(event: .mainSettingButton).send()
                                store.send(.delegate(.pushSettingView))
                            }
                        },
                        trailing: {
                            DNavigationBarButton(.image(.reward)) {
                                store.send(.touchRewardButton)
                            }
                        }
                    )
                    DText(store.userName, style: .h1, weight: .bold, color: ColorPalette.Neutral.gray95)
                }
                
                Spacer()
                
                if store.canWriteRecord {
                    RecordButton()
                } else {
                    HStack(spacing: 4) {
                        DImage(DImageAsset.starShape)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white)
                            .frame(width: 22)
                        DText("오늘 남길 수 있는 기록은 모두 작성했어요!", style: .b2, weight: .semibold, color: .white)
                    }
                    .background {
                        Ellipse()
                            .fill(ColorPalette.Semantic.mainToolTipBackground)
                            .frame(height: 14)
                            .blur(radius: 20.0)
                            .opacity(0.6)
                    }
                }
            }
            .padding(.bottom, .s3)
            
            if store.isPresentingNewStarBottle {
                NewStarBottleView()
            }
            
            if store.isPresentingAlreadyWrite {
                OnboardingEndView()
            }
            
            if store.isPresentingRewardToolTipView {
                RewardToolTipView()
            }
            
            if store.isPresentingTodayFortuneView {
                TodayFortuneView(
                    isNotificationEnabled: store.isNotificationEnabled
                )
            }
            
            if store.isLoading {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
            }
        }
        .safeAreaPadding(.bottom)
        .background {
            StarBottleView(
                records: store.records,
                decorationData: store.decorationData,
                starBottleAction: $store.starBottleAction,
                onFortuneTobyTapGesture: {
                    store.send(.touchFortuneToby)
                },
                onTapGesture: {
                    GA.Click(event: .mainRecordArchiveButton).send()
                    store.send(.delegate(.pushRecordListView))
                }
            )
            .ignoresSafeArea(.container)
        }
        .onAppear {
            store.send(.onAppear)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                store.send(.refreshNotificationPermissionStatus)
            }
        }
        .modal(
            isPresented: $store.isPresentDailyFortuneModal,
            config: ModalConfig(
                backgroundColor: ColorPalette.Semantic.dailyFortuneBackground
            )
        ) {
            dailyFortune()
        } onDismiss: {
            Task { @MainActor in
                if !store.shouldPushRecordAfterFortuneConfirm {
                    toastManager.show(.dailyFortuneNotice)
                }
                await store.send(.completeDailyFortuneDismiss).finish()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView(
        store: Store(
            initialState: DefaultStateFactory().makeMainState(
                context: MainStore.Context(
                    records: [],
                    hasRecord: (true, true),
                    isPresentingNewStarBottle: false,
                    decorationData: DecorationData(
                        backgroundRewardData: nil,
                        effectRewardData: nil,
                        decorationRewardName: nil,
                        decorationRewardId: nil,
                        bottleRewardId: nil,
                        bottleShape: .default
                    )
                )
            )
        ) {
            MainStore()
        }
    )
}
