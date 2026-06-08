//
//  DecorationView.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Lottie
import Domain

struct DecorationView: View {
    @EnvironmentObject private var toastManager: ToastManager
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<DecorationStore>
    
    private static let topSectionRatio: CGFloat = 0.6
    private static let topSectionMinHeight: CGFloat = 280
    private static let bottomSectionMinHeight: CGFloat = 220
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let layout = sectionHeights(for: proxy.size.height)
                
                VStack(spacing: 0) {
                    VStack {
                        DNavigationBar(
                            leading: {
                                DNavigationBarButton(.image(.arrowLeft)) {
                                    store.send(.touchBackButton)
                                }
                            },
                            title: {
                                DText("꾸미기", style: .b1, weight: .semibold, color: .white)
                            },
                            trailing: {
                                Button {
                                    store.send(.touchSaveButton)
                                } label: {
                                    DText("완료", style: .b1, weight: .semibold, color: store.disabledSaveButton
                                               ? .white.opacity(0.4)
                                               : .white
                                        )
                                        .frame(height: .s3)
                                }
                                .disabled(store.disabledSaveButton)
                            }
                        )
                        Spacer()
                    }
                    .frame(height: layout.top)
                    .background {
                        StarBottleView(
                            records: store.monthlyRecords,
                            decorationData: store.decorationData,
                            viewType: .decoration,
                            starBottleAction: $store.starBottleAction
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    VStack {
                        HStack(spacing: .s4) {
                            ForEach(
                                RewardItemCategory.cases,
                                id: \.self
                            ) { item in
                                Button {
                                    store.send(.touchRewardItemCategoryButton(item))
                                } label: {
                                    if (store.selectedRewardItemCategory == item) {
                                        DText(item.title, style: .b1, weight: .bold, color: Color.white)
                                    } else {
                                        DText(item.title, style: .b1, weight: .bold, color: ColorPalette.Primary.deepBlue80)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, .defaultLayoutPadding)
                        .padding(.top, .s5)
                        
                        if store.itemList.isEmpty {
                            Spacer()
                            EmptyItemListView()
                            Spacer()
                        } else {
                            ItemGridView(itemCategory: store.selectedRewardItemCategory)
                            Spacer()
                        }
                    }
                    .frame(height: layout.bottom)
                    .background(ColorPalette.Primary.deepBlue60)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            if store.isPresentingGuideBottomSheet {
                DecorationGuideBottomSheet()
            }
            
            if store.isPresentingFinalBottomSheet {
                DecorationFullBottomSheet()
                LottieView(animation: store.confettiLottieAnimation)
                    .playing(loopMode: .playOnce)
                    .aspectRatio(1.0, contentMode: .fit)
            }
            
            if store.isPresentingDecorationGuideAlert {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    VStack(spacing: .s4) {
                        DText("설정 > 꾸미기에서\n언제든 바꿀 수 있어요", style: .h2, weight: .bold, color: ColorPalette.Primary.deepBlue99)
                            .lineSpacing(8)
                            .multilineTextAlignment(.center)
                        HStack(spacing: 10) {
                            Button {
                                store.send(.cancelSave)
                            } label: {
                                ZStack {
                                    RoundedRectangle(
                                        cornerRadius: .s1 / 2,
                                        style: .continuous
                                    )
                                    .fill(ColorPalette.Primary.deepBlue50)
                                    .frame(height: 58)
                                    DText("돌아가기", style: .h3, weight: .bold, color: .white)
                                }
                            }
                            
                            Button {
                                store.send(.saveDecorationItem)
                            } label: {
                                ZStack {
                                    RoundedRectangle(
                                        cornerRadius: .s1 / 2,
                                        style: .continuous
                                    )
                                    .fill(ColorPalette.Neutral.gray95)
                                    .frame(height: 58)
                                    DText("저장하기", style: .h3, weight: .bold, color: ColorPalette.Primary.deepBlue20)
                                }
                            }
                        }
                    }
                    .padding(.defaultLayoutPadding)
                    .background {
                        RoundedRectangle(
                            cornerRadius: .s1,
                            style: .continuous
                        )
                        .fill(ColorPalette.Primary.deepBlue60)
                    }
                    .padding(.defaultLayoutPadding)
                }
            }
        }
        .onChange(of: store.toastType) { _, type in
            toastManager.show(type)
        }
        .onAppear {
            store.send(.onAppear)
            store.send(.toggleGuideBottomSheet)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func sectionHeights(for totalHeight: CGFloat) -> (top: CGFloat, bottom: CGFloat) {
        let safeTotalHeight = max(totalHeight, 0)
        let idealTopHeight = safeTotalHeight * Self.topSectionRatio
        let availableTopMax = max(safeTotalHeight - Self.bottomSectionMinHeight, 0)
        let topHeight = min(max(idealTopHeight, Self.topSectionMinHeight), availableTopMax)
        let bottomHeight = max(safeTotalHeight - topHeight, 0)
        return (topHeight, bottomHeight)
    }
}

#Preview {
    {
        var decorationItem: [RewardItemCategory: [Reward]] = [:]
        for key in RewardItemCategory.allCases {
            decorationItem[key] = Reward.previewAllData.filter{ $0.category == key }
            switch key {
            case .decoration, .effect, .sound:
                let itemCount = decorationItem[key]?.count ?? 0
                if (itemCount < 2) {
                    decorationItem[key] = []
                }
            default:
                break
            }
        }
        let context = DecorationStore.Context(
            records: [],
            decorationItem: decorationItem,
            currentDecorationItem: [],
            selectedCategory: .background,
            decorationData: DecorationData(
                backgroundRewardData: nil,
                effectRewardData: nil,
                decorationRewardName: nil,
                decorationRewardId: nil,
                bottleRewardId: nil,
                bottleShape: .bead
            )
        )
        var state = MainStateFactory().makeDecorationState(context: context)
        state.monthlyRecords = []
        let store = MainStoreFactory().makeDecorationStore(state: state)
        return DecorationView(store: store)
    }()
}
