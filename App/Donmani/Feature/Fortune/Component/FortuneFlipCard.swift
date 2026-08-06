//
//  FortuneFlipCard.swift
//  Donmani
//
//  Created by 문종식 on 8/6/26.
//

import SwiftUI
import Kingfisher
import DesignSystem
import Domain

struct FortuneFlipCard: View, Animatable {
    let fortune: Fortune
    var progress: CGFloat

    init(
        fortune: Fortune,
        isFlipped: Bool
    ) {
        self.fortune = fortune
        self.progress = isFlipped ? 1 : 0
    }

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        ZStack {
            if progress < 0.5 {
                frontCardFace
                    .scaleEffect(
                        x: max(0.001, 1 - (progress * 2)),
                        y: 1,
                        anchor: .center
                    )
            } else {
                cardContent
                    .scaleEffect(
                        x: max(0.001, (progress - 0.5) * 2),
                        y: 1,
                        anchor: .center
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var frontCardFace: some View {
        if let imageURL = URL(string: fortune.imageUrl), !fortune.imageUrl.isEmpty {
            KFImage(imageURL)
                .placeholder {
                    cardBackground(ColorPalette.Semantic.dailyFortuneBackground)
                }
                .cancelOnDisappear(false)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
        } else {
            cardBackground(ColorPalette.Semantic.dailyFortuneBackground)
        }
    }

    private func cardBackground(_ color: Color) -> some View {
        RoundedRectangle(
            cornerRadius: .s3,
            style: .continuous
        )
        .fill(color)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var cardContent: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                DImage(DImageAsset.dailyFortune)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 68, height: 68)
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    DText("토비 요정이 전해주는", style: .b2, weight: .medium, color: .fromHex("#806AEB"))
                        .multilineTextAlignment(.leading)
                    DText(fortune.day.fortuneDate, style: .h3, weight: .bold, color: .fromHex("#04091E"))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            DText(fortune.content, style: .b1, weight: .regular, color: .fromHex("#04091E"))
                .lineSpacing(8)
            HStack {
                DText("⭐️ \(fortune.item)", style: .b3, weight: .medium, color: .fromHex("#FFFFFF"))
                    .kerning(-0.5)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background {
                        Capsule()
                            .fill(Color.fromHex("#6045E6"))
                    }
                Spacer()
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            cardBackground(ColorPalette.Semantic.dailyFortuneBackground)
        }
    }
}
