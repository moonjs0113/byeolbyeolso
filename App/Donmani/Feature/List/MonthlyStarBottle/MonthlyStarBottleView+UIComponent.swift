//
//  MonthlyStarBottleView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/27/25.
//

import SwiftUI
import DesignSystem

extension MonthlyStarBottleView {
    struct TopBannerView: View {
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: .s5, style: .circular)
                    .fill(ColorPalette.Primary.deepBlue60)
                    .frame(height: 56)
                HStack(alignment: .center, spacing: 8) {
                    DImage(DImageAsset.notice)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .s3, height: .s3)
                    DText("매 월 1일에 새로운 별통이가 열려요", style: .b1, weight: .regular, color: ColorPalette.Neutral.gray95)
                    Spacer()
                }
                .padding(.s5)
            }
            .padding(.top, .s5)
        }
    }
}
