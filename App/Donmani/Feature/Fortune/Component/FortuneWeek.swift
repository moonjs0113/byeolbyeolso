//
//  FortuneWeek.swift
//  Donmani
//
//  Created by 문종식 on 6/21/26.
//

import SwiftUI
import Domain
import DesignSystem

struct FortuneWeek: View {
    private let week: [Day]
    private let selectedDay: Day
    private let touchDayAction: (Day) -> Void
    
    init(
        week: [Day],
        selectedDay: Day,
        touchDayAction: @escaping (Day) -> Void
    ) {
        self.week = week
        self.selectedDay = selectedDay
        self.touchDayAction = touchDayAction
    }
    
    var body: some View {
        HStack {
            ForEach(week.indices, id: \.self) { index in
                Button {
                    touchDayAction(week[index])
                } label: {
                    dayComponent(day: week[index])
                        .frame(width: 40)
                }
                if index < week.count - 1 {
                     Spacer()
                 }
            }
        }
    }
    
    @ViewBuilder
    private func dayComponent(day: Day) -> some View {
        let isSelected = selectedDay == day

        VStack(spacing: 0) {
            DText(
                day.weekday,
                style: .b3,
                weight: .bold,
                color: ColorPalette.Primary.deepBlue90
            )
            .frame(height: 20)
            if isSelected {
                VStack(alignment: .center, spacing: 0) {
                    Spacer().frame(height: 4)
                    Circle()
                        .fill(
                            Color.fromHex("#15BD66")
                        )
                        .frame(width: 4, height: 4)
                }
            } else {
                Spacer().frame(height: 8)
            }
            DText(
                "\(day.day)",
                style: .b3,
                weight: .bold,
                color: isSelected ? Color.fromHex("#15BD66") : Color.white
            )
            .frame(height: 20)
            Spacer().frame(height: 2)
            if (day == Day.today) {
                DText(
                    "오늘",
                    style: .b2,
                    weight: .bold,
                    color: Color.fromHex("#2D355B")
                )
                .frame(height: 14)
            } else {
                Spacer().frame(height: 14)
            }
        }
    }
}

#Preview {
    let week = (0..<7)
        .compactMap { offset in
            Calendar.current.date(byAdding: .day, value: -(6 - offset), to: Date())
        }
        .map { date in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            return Day(
                year: components.year ?? 0,
                month: components.month ?? 0,
                day: components.day ?? 0
            )
        }

    FortuneWeek(
        week: week,
        selectedDay: week.last ?? .today,
        touchDayAction: { _ in }
    )
}
