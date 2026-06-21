//
//  RecordListView.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Domain

struct RecordListView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: StoreOf<RecordListStore>
    
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
                        DText("\(store.day.year)년 \(store.day.month)월 기록", style: .b1, weight: .semibold, color: .white)
                    },
                    trailing: {
                        if store.isShowBottleCalendarNavigationButton {
                            DNavigationBarButton(.image(.bottle)) {
                                store.send(.pushBottleCalendarView)
                            }
                        }
                    }
                )
                
                if store.records.isEmpty {
                    ZStack {
                        VStack {
                            SimpleStatisticsView(store: store)
                                .padding(.top, .s5)
                                .onTapGesture {
                                    store.send(.touchStatisticsView(true))
                                }
                            Spacer()
                        }
                        EmptyGuideView(store: store)
                    }
                } else {
                    RecordScrollView(store: store)
                }
                
                BannerAdView(
                    width: .screenWidth,
                    cornerRadius: 0
                )
            }
            
            if store.isPresentingBottleCalendarToolTipView {
                BottleCalendarToolTipView(store: store)
            }
            
        }
        .navigationBarBackButtonHidden()
        .background {
            BackgroundView()
        }
        .onAppear {
            GA.View(event: .recordhistory).send()
            store.send(.onAppear)
        }
        .onDisappear {
            if store.records.count > 0 {
                let id = store.dateSet.count - 1
                DispatchQueue.global().async {
                    GA.Impression(event: .recordhistory).send(parameters: [.recordID: id])
                }
            }
        }
    }
}

#Preview {
    {
        let context = RecordListStore.Context(day: .today, records: [], false)
        let state = DefaultStateFactory().makeMonthlyRecordListState(context: context)
        let store = DefaultStoreFactory().makeMonthlyRecordListStore(state: state)
        return RecordListView(store: store)
    }()
}
