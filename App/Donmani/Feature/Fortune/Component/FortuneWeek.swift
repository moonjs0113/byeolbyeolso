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
    
    init(week: [Day]) {
        self.week = week
    }
    
    var body: some View {
        HStack {
            ForEach(week, id: \.yyyyMMdd) { day in
                dayComponent(day: day)
            }
        }
    }
    
    @ViewBuilder
    private func dayComponent(day: Day) -> some View {
        VStack(spacing: 0) {
            DText(
                day.weekday,
                style: .b3,
                weight: .bold,
                color: ColorPalette.Primary.deepBlue90
            )
            .frame(height: 20)
            Spacer().frame(height: 8)
            DText(
                "\(day.day)",
                style: .b3,
                weight: .bold,
                color: Color.fromHex("#15BD66")
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
    FortuneWeek(
        week: (0..<7) 
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
    )
}
