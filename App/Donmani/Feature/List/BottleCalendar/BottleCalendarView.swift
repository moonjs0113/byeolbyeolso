//
//  BottleCalendarView.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import GoogleMobileAds

struct BottleCalendarView: View {
    @EnvironmentObject private var toastManager: ToastManager
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<BottleCalendarStore>
    
    var body: some View {
        ZStack {
            VStack(alignment: .center,spacing: 0) {
                DNavigationBar(
                    leading: {
                        DNavigationBarButton(.arrowLeft) {
                            dismiss()
                        }
                    },
                    title: {
                        DText("별통이 모아보기")
                            .style(.b1, .semibold, .white)
                    }
                )
                
                ScrollView {
                    BannerAdView(width: .adScreenWidth)
                    
                    if store.isPresentingTopBanner {
                        TopBannerView()
                    }
                    MonthlyBottleGridView()
                        .padding(.top, 16)
                }
                .frame(width: .screenWidth)
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .onChange(of: store.toastType) { _, type in
            toastManager.show(type)
            store.send(.completeShowToast)
        }
        .navigationBarBackButtonHidden()
        .background {
            BackgroundView()
        }
        .overlay {
            if store.isPresentLoadingIndicator {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.gray)
                        .scaleEffect(2.0)
                }
            }
        }
    }
}

#Preview {
    {
        let context = RecordCountSummary(year: 2025, monthlyRecords: [:])
        let state = MainStateFactory().makeBottleCalendarState(context: context)
        let store = MainStoreFactory().makeBottleCalendarStore(state: state)
        return BottleCalendarView(store: store)
    }()
}
