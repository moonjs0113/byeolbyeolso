//
//  MainView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

extension MainView {
    func RecordButton() -> some View {
        Button {
            GA.Click(event: .mainRecordButton).send()
            store.send(.delegate(.pushRecordEntryPointView))
        } label: {
            ZStack {
                Circle()
                    .fill(ColorPalette.Secondary.purpleBlue70)
                DImage(.plus).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s2)
            }
        }
        .frame(width: 70, height: 70)
        .overlay {
            if store.canWriteRecord && store.isPresentingRecordYesterdayToolTip {
                VStack {
                    RecordYesterdayViewToolTip()
                        .frame(width: .screenWidth)
                    Spacer()
                    //                .padding(.vertical, 16 + 70)
                }
                .offset(y: -(8 + 35))
            }
        }
    }
    
    func RecordYesterdayViewToolTip() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                HStack {
                    DText("어제 소비도 정리해 보아요", style: .b3, weight: .medium, color: .white)
                    Button {
                        store.send(.closePopover)
                    } label: {
                        DImage(.close).image
                            .resizable()
                            .frame(width: .s5, height: .s5)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                Spacer()
            }
            HStack {
                Spacer()
                Triangle(direction: .down)
                    .fill(.black)
                    .frame(width: 14, height: 8)
                Spacer()
            }
        }
    }
    
    func RewardToolTipView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Triangle(direction: .up)
                    .fill(ColorPalette.Primary.deepBlue70)
                    .frame(width: 14, height: 8)
                    .padding(.trailing, 12)
            }
            HStack {
                Spacer()
                DText("선물 도착!✨", style: .b3, weight: .semibold, color: .white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(ColorPalette.Primary.deepBlue70)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            Spacer()
        }
        .padding(.top, 42)
        .padding(.horizontal, 13)
    }
    
    @ViewBuilder
    func dailyFortune() -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                DImage(.dailyFortune)
                    .image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 68, height: 68)
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    DText("토비 요정이 전해주는", style: .b2, weight: .medium, color: .fromHex("#806AEB"))
                        .multilineTextAlignment(.leading)
                    DText(store.dailyFortune.day.fortuneDate, style: .h3, weight: .bold, color: .fromHex("#04091E"))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            // spacing 16
            DText(store.dailyFortune.content, style: .b1, weight: .regular, color: .fromHex("#04091E"))
                .lineSpacing(8)
            // spacing 16
            HStack {
                DText("⭐️ \(store.dailyFortune.item)", style: .b3, weight: .medium, color: .fromHex("#FFFFFF"))
                    .kerning(-0.5)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background {
                        Capsule()
                            .fill(Color.fromHex("6045E6"))
                    }
                Spacer()
            }
            // spacing 16
            Button {
                store.send(.touchDailyFortuneConfirm)
            } label: {
                ZStack {
                    RoundedRectangle(
                        cornerRadius: .s5,
                        style: .continuous
                    )
                    .fill(Color.fromHex("#F8F9FA"))
                    DText(store.shouldPushRecordAfterFortuneConfirm ? "기록하기" : "행운 받아가기", style: .b1, weight: .bold, color: .fromHex("#04091E"))
                }
            }
            .frame(height: 52)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
    }
}
