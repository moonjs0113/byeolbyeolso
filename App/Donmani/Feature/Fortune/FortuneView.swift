//
//  FortuneView.swift
//  Donmani
//
//  Created by 문종식 on 6/21/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

struct FortuneView: View {
    @Bindable var store: StoreOf<FortuneStore>
    
    var body: some View {
        VStack {
            DNavigationBar(
                leading: {
                    DNavigationBarButton(.image(.arrowLeft)) {
                        store.send(.touchBackButton)
                    }
                },
                title: {
                    DText(
                        "\(store.month)월 운세 히스토리",
                        style: .b1,
                        weight: .semibold,
                        color: .white
                    )
                },
            )
            
            Spacer().frame(height: 16)
            
            FortuneWeek(
                week: store.weekday,
                selectedDay: store.selectedDay
            ) { day in
                store.send(.touchDay(day))
            }
            .padding(
                .horizontal,
                .defaultLayoutPadding
            )
            
            Spacer().frame(height: 64)
            
            FortunePage(
                fortunes: store.fortunes,
                selectedDay: $store.selectedDay,
                referenceToday: store.referenceToday,
                referenceYesterday: store.referenceYesterday,
                hasTodayRecord: store.hasTodayRecord,
                hasYesterdayRecord: store.hasYesterdayRecord,
                isFortuneCardFlipped: { day in
                    store.flippedDays.contains(day)
                },
                touchFortuneCardAction: { day in
                    store.send(.touchFortuneCard(day))
                },
                touchRecordAction: { day in
                    store.send(.touchRecordButton(day))
                }
            )
            
            Spacer()
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationBarBackButtonHidden()
        .background {
            BackgroundView()
        }
    }
}

#Preview {
    FortuneView(
        store: DefaultStoreFactory().makeFortuneStore(
            state: DefaultStateFactory().makeFortuneState(
                context: FortuneStore.Context(
                    fortunes: (0..<7)
                        .compactMap { offset in
                            Calendar.current.date(byAdding: .day, value: -(6 - offset), to: Date())
                        }
                        .map { date in
                            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                            return Fortune(
                                day: Day(
                                    year: components.year ?? 0,
                                    month: components.month ?? 0,
                                    day: components.day ?? 0
                                ),
                                title: "새로운 한 주를 시작하는 당신에게 행운이 배달돼요!📦",
                                subtitle: "",
                                content: "새로운 달이 시작되었으니 오늘은 가벼운 마음으로 지갑 속 영수증을 정리하며 마음을 정돈해 보세요. 깨끗해진 지갑만큼 이번 달에는 기분 좋은 소비 행운이 가득 들어올 것만 같은 예감이 들거든요.",
                                item: "연두색"
                            )
                        },
                    referenceToday: .today,
                    referenceYesterday: .yesterday,
                    hasTodayRecord: false,
                    hasYesterdayRecord: false
                )
            )
        )
    )
}
