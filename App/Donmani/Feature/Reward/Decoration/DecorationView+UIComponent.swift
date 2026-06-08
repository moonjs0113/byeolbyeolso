//
//  DecorationView.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Lottie

extension DecorationView {
    func EmptyItemListView() -> some View {
        VStack(spacing: 12) {
            DText("아직 아이템이 없어요!", style: .h2, weight: .bold, color: ColorPalette.Primary.deepBlue99)
            DText("기록하면 아이템을 받을 수 있어요", style: .b2, weight: .regular, color: ColorPalette.Primary.deepBlue90)
        }
    }
    
    func ItemGridView(itemCategory: RewardItemCategory) -> some View {
        let horizontalPadding: CGFloat = .defaultLayoutPadding
        let itemSpacing: CGFloat = 5
        let rowSpacing: CGFloat = 10
        return GeometryReader { proxy in
            let availableWidth = max(proxy.size.width - horizontalPadding * 2, 0)
            let itemSize = max((availableWidth - itemSpacing * 2) / 3, 0)
            let columns = Array(
                repeating: GridItem(.fixed(itemSize), spacing: itemSpacing),
                count: 3
            )
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: rowSpacing) {
                    ForEach(store.decorationItem[itemCategory, default: []], id: \.id) { reward in
                        Button {
                            store.send(.touchRewardItem(itemCategory, reward))
                        } label: {
                            ZStack {
                                ItemGridImage(reward: reward)
                                    .frame(width: itemSize, height: itemSize)
                                if let selectedItem = store.selectedDecorationItem[itemCategory] {
                                    if selectedItem.id == reward.id {
                                        RoundedRectangle(
                                            cornerRadius: .s5,
                                            style: .continuous
                                        )
                                        .strokeBorder(.white, lineWidth: 2)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, .defaultLayoutPadding / 2.0)
                .padding(.horizontal, horizontalPadding)
            }
        }
    }
    
    func ItemGridImage(reward: Reward) -> some View {
        let mapper = RewardResourceMapper(id: reward.id, category: reward.category)
        var image = mapper.image()
        if reward.category == .bottle {
            image = mapper.image(isPreview: true)
        }
        return Group {
            ZStack {
                if reward.category == .background {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(ColorPalette.Primary.deepBlue50)
                        .overlay {
                            if reward.category == .decoration && reward.id == 23 {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .padding(-5)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            } else {
                                image
                                    .resizable()
                                    .padding((.s3 / 3) + 0.5)
                            }
                        }
                }
                if (reward.newAcquiredFlag && !reward.name.contains("기본")) {
                    HStack {
                        VStack {
                            Circle()
                                .fill(ColorPalette.Semantic.noticeDot)
                                .frame(width: .s5, height: .s5)
                                .overlay {
                                    DText("N", style: .b4, weight: .bold, color: .white)
                                        .multilineTextAlignment(.center)
                                }
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(10)
                }
            }
        }
    }
    
    func StarBottle(
        backgroundShapeImage: DImage
    ) -> some View {
        backgroundShapeImage
            .resizable()
            .scaledToFit()
            .padding(.vertical, 50)
    }
}
