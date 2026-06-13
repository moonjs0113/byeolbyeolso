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
import Domain

struct BottleCalendarView: View {
    @EnvironmentObject private var toastManager: ToastManager
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<BottleCalendarStore>
    
    var body: some View {
        ZStack {
            VStack(
                alignment: .center,
                spacing: 0
            ) {
                DNavigationBar(
                    leading: {
                        DNavigationBarButton(.image(.arrowLeft)) {
                            dismiss()
                        }
                    },
                    title: {
                        Button {
                            store.send(.touchTitle)
                        } label: {
                            HStack {
                                DText("\(store.selectedYear)년 별통이", style: .b1, weight: .semibold, color: .white)
                                DImage(DImageAsset.downArrow)
                            }
                        }
                    }
                )
                BannerAdView(width: .adScreenWidth)
                if store.isPresentingTopBanner {
                    TopBannerView()
                }
                TabView(selection: $store.selectedYear) {
                    ForEach(store.years, id: \.self) { year in
                        ScrollView {
                            MonthlyBottleGridView(
                                year: year,
                                months: year == 2025 ? (3...12) : (1...12)
                            )
                                .padding(.top, 16)
                        }
                        .frame(width: .screenWidth)
                        .ignoresSafeArea(edges: .bottom)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            if store.isPresentYearSelectorBottomSheet {
                YearSelectBottomSheet()
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
        let state = DefaultStateFactory().makeBottleCalendarState(context: [2025: context])
        let store = DefaultStoreFactory().makeBottleCalendarStore(state: state)
        return BottleCalendarView(store: store)
    }()
}
