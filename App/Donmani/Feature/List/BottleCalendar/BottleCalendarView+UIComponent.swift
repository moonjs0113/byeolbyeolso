//
//  BottleCalendarView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import SwiftUI
import DesignSystem

extension BottleCalendarView {
    func TopBannerView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: .s5, style: .circular)
                .fill(ColorPalette.Primary.deepBlue60)
                .frame(height: 56)
            HStack(alignment: .center, spacing: 8) {
                DImage(.notice)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3, height: .s3)
                DText("매 월 1일에 새로운 별통이가 열려요", style: .b1, weight: .regular, color: ColorPalette.Neutral.gray95)
                Spacer()
                
                Button {
                    store.send(.closeTopBanner)
                } label: {
                    DImage(.close)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .s4, height: .s4)
                }
            }
            .padding(.s5)
        }
        .padding(.horizontal, .defaultLayoutPadding)
        .padding(.top, .s5)
    }
    
    func MonthlyBottleGridView(
        year: Int,
        months: ClosedRange<Int>
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(minimum: 0)), count: 3),
            spacing: .s3
        ) {
            ForEach(months, id: \.self) { month in
                HStack {
                    Spacer()
                    MonthlyBottleView(
                        month: month,
                        count: store.starCount[year]?[month] ?? 0
                    )
                    .onTapGesture {
                        GA.Click(event: .list별통이Button).send(parameters: [.별통이ID: 2500 + month])
                        if ((store.starCount[year]?[month] ?? 0) == 0) {
                            store.send(.showEmptyBottleToast)
                        } else {
                            store.send(.showLoading)
                            store.send(.fetchMonthlyRecord(month))
                        }
                        
                    }
                    Spacer()
                }
            }
        }
    }
    
    func MonthlyBottleView(
        month: Int,
        count: Int
    ) -> some View {
        VStack(alignment: .center, spacing: 4) {
            if (count == -1) {
                DImage(.calendarStarBottleLock)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 116)
            } else {
                ZStack {
                    DImage(.calendarStarBottleOpen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    VStack(spacing: 4) {
                        DImage(.starSmall)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s4, height: .s4)
                        HStack(alignment: .bottom,spacing: 0) {
                            DText("\(count)", style: .b2, weight: .semibold, color: ColorPalette.Neutral.gray80)
                            DText("/\(store.lastDaysOfMonths[month, default: 0])", style: .b3, weight: .semibold, color: ColorPalette.Primary.deepBlue80)
                        }
                    }
                    .padding(.top, 6)
                }
                .frame(height: 116)
            }
            
            DText("\(month)월", style: .b2, weight: .semibold, color: (count > -1) ? ColorPalette.Neutral.gray99 : ColorPalette.Primary.deepBlue80)
        }
    }
}
