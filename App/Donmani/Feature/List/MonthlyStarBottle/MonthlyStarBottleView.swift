//
//  MonthlyStarBottleView.swift
//  Donmani
//
//  Created by 문종식 on 3/27/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct MonthlyStarBottleView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<MonthlyStarBottleStore>
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                DNavigationBar(
                    leading: {
                        DNavigationBarButton(.image(.arrowLeft)) {
                            dismiss()
                        }
                    },
                    title: {
                        DText("\(store.day.year % 100)년 \(store.day.month)월", style: .b1, weight: .semibold, color: .white)
                    }
                )
                
                ZStack {
                    if store.records.isEmpty {
                        VStack {
                            TopBannerView()
                            Spacer()
                        }
                        .padding(.horizontal, .defaultLayoutPadding)
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .background {
            if store.records.isEmpty {
                EmptyStarBottleView()
            } else {
                StarBottleView(
                    records: store.records,
                    decorationData: store.decorationData,
                    starBottleAction: $store.starBottleAction
                ) {
                    store.send(.didTapStarBottle)
                }
                .ignoresSafeArea(.container)
            }
        }
    }
}

struct EmptyStarBottleView: View {
    var body: some View {
        ZStack {
            BackgroundView(colors: [
                ColorPalette.Semantic.backgroundTop,
                ColorPalette.Semantic.backgroundBottom,
            ])
            
            DImage(DImageAsset.backgroundStar)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
            
            DImage(DImageAsset.starBottleLock)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 10)
                .padding(.horizontal, 38)
        }
        .ignoresSafeArea(.container)
    }
}

#Preview {
    {
        let context = MonthlyStarBottleStore.Context(
            day: .today,
            records: [],
            decorationData: DecorationData(
                backgroundRewardData: nil,
                effectRewardData: nil,
                decorationRewardName: nil,
                decorationRewardId: nil,
                bottleRewardId: nil,
                bottleShape: .default
            )
        )
        let state = MainStateFactory().makeMonthlyStarBottleState(context: context)
        let store = MainStoreFactory().makeMonthlyStarBottleStore(state: state)
        return MonthlyStarBottleView(store: store)
    }()
}
