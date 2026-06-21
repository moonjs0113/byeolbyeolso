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
                            let day = Day(
                                year: components.year ?? 0,
                                month: components.month ?? 0,
                                day: components.day ?? 0
                            )
                            return Fortune(
                                day: day,
                                title: "\(day.day)일 운세",
                                subtitle: "",
                                content: "",
                                item: ""
                            )
                        }
                )
            )
        )
    )
}
