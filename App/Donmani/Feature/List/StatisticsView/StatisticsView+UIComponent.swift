//
//  StatisticsView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/28/25.
//

import SwiftUI
import DesignSystem

extension StatisticsView {
    func TopBannerView() -> some View {
        HStack(alignment: .top, spacing: .s5 / 2) {
            VStack {
                DImage(DImageAsset.notice)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3, height: .s3)
            }
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    DText("요약 페이지가 곧 업데이트 될거예요", style: .b1, weight: .semibold, color: ColorPalette.Neutral.gray95)
                    DText("기록을 모아 분석해 드릴게요!", style: .b2, weight: .regular, color: ColorPalette.Primary.deepBlue95)
                }
                Button {
                    store.send(.touchProposeFunction)
                } label: {
                    HStack(spacing: 4) {
                        DText("기능 요청하기", style: .b2, weight: .medium, color: ColorPalette.Primary.deepBlue99)
                        
                        DImage(DImageAsset.arrowRight)
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(ColorPalette.Primary.deepBlue99)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s5, height: .s5)
                    }
                }
            }
            Spacer()
        }
        .padding(.s5)
        .background {
            RoundedRectangle(cornerRadius: .s5, style: .circular)
                .fill(ColorPalette.Primary.deepBlue60)
        }
        .padding(.horizontal, .defaultLayoutPadding)
    }
    
    func CategoryStatisticsView(flag: RecordContentType) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            DText("\(flag.title) 소비 \(flag == .good ? store.goodTotalCount : store.badTotalCount)", style: .b1, weight: .bold, color: ColorPalette.Neutral.gray99)
            ForEach(RecordCategory.cases(type: flag), id: \.self) { category in
                CategoryRatioView(
                    flag: flag,
                    category: category,
                    ratio: store.recordRatio[category, default: 0.0]
                )
            }
        }
        .padding(.s5)
        .background {
            RoundedRectangle(cornerRadius: .s4, style: .circular)
                .fill(ColorPalette.Primary.deepBlue70)
        }
        .padding(.horizontal, .defaultLayoutPadding)
    }
    
    func CategoryRatioView(
        flag: RecordContentType,
        category: RecordCategory,
        ratio: CGFloat
    ) -> some View {
        HStack {
            HStack(spacing: 12) {
                category
                    .smallImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s1, height: .s1)
                DText(category.title, style: .b2, weight: .medium, color: ColorPalette.Neutral.gray95)
            }
            
            Spacer()
            
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(
                                color: ColorPalette.Primary.deepBlue99,
                                location: ratio
                            ),
                            .init(
                                color: ColorPalette.Primary.deepBlue80,
                                location: ratio
                            )
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: .screenWidth / 3, height: 6)
            VStack(alignment: .trailing) {
                DText("\(String(format: "%.f", ratio * 100))%", style: .b2, weight: .semibold, color: ColorPalette.Neutral.gray95)
                    .frame(width: 40)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}
