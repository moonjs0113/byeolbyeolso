//
//  FortunePageItem.swift
//  Donmani
//
//  Created by 문종식 on 8/6/26.
//

import SwiftUI
import DesignSystem
import Domain

struct FortunePageItem: View {
    let fortune: Fortune
    let selectedDay: Day
    let referenceToday: Day
    let referenceYesterday: Day
    let hasTodayRecord: Bool
    let hasYesterdayRecord: Bool
    let isFlipped: Bool
    let touchFortuneCardAction: (Day) -> Void
    let touchRecordAction: (Day) -> Void

    private var isSelected: Bool {
        fortune.day == selectedDay
    }

    private var recordButtonLabel: String? {
        if fortune.day == referenceToday, !hasTodayRecord {
            return "오늘 소비 기록하기"
        }
        if fortune.day == referenceYesterday, !hasYesterdayRecord {
            return "어제 소비 기록하기"
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 16) {
            FortuneFlipCard(
                fortune: fortune,
                isFlipped: isFlipped
            )
            .frame(height: 313)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: .s5,
                    style: .continuous
                )
            )
            .contentShape(
                RoundedRectangle(
                    cornerRadius: .s5,
                    style: .continuous
                )
            )
            .onTapGesture {
                guard isSelected else {
                    return
                }
                withAnimation(.easeInOut(duration: 0.36)) {
                    touchFortuneCardAction(fortune.day)
                }
            }
            .allowsHitTesting(isSelected)

            VStack(alignment: .leading, spacing: 0) {
                DText(
                    fortune.day.fortuneDate,
                    style: .b2,
                    weight: .regular,
                    color: Color.white
                )
                DText(
                    fortune.subtitle,
                    style: .h2,
                    weight: .bold,
                    color: Color.white
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let recordButtonLabel {
                Button {
                    guard isSelected else {
                        return
                    }
                    touchRecordAction(fortune.day)
                } label: {
                    ZStack {
                        RoundedRectangle(
                            cornerRadius: .s5,
                            style: .continuous
                        )
                        .fill(ColorPalette.Primary.deepBlue20)
                        DText(
                            recordButtonLabel,
                            style: .h3,
                            weight: .bold,
                            color: .white
                        )
                    }
                }
                .frame(height: 58)
                .disabled(!isSelected)
                .allowsHitTesting(isSelected)
            }

            Spacer()
        }
    }
}
