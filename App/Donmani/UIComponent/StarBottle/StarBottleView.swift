//
//  StarBottleView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import SpriteKit
import DesignSystem
import ComposableArchitecture
import Domain



enum StarBottleAction: Equatable {
    case addNewStar(Record)
    
    /// 전체 아이템 교체
    case changeRewardItem(RewardItemData)
    
    /// 카테고리별 아이템 교체
    case changeBackgroundItem(Data)
    case changeEffectItem(Data?)
    case changeDecorationItem(Int?, String?)
    case changeBottleItem(Int, BottleShape)

    case none
}

enum StarBottleViewType {
    case `default`
    case decoration
}

struct StarBottleView: View {
    static var width: CGFloat {
        .screenWidth - (38 * 2)
    }
    
    static var height: CGFloat {
        width * 1.25
    }
    
    var width: CGFloat {
        .screenWidth - (38 * 2) - (self.viewType == .decoration ? 90 : 0)
    }
    
    var height: CGFloat {
        width * 1.25
    }
    
    let motionManager = MotionManager()
    let viewType: StarBottleViewType
    
    var spaceVacanceItemOffset: CGPoint {
        let offsetY: CGFloat = switch bottleShape {
        case .bead:
            -.screenWidth * 0.21 * 0.4
        case .heart:
            viewType == .decoration ? -.screenWidth * 0.21 * 0.3 : -.screenWidth * 0.21 * 0.1
        case .default:
            -.screenWidth * 0.21 * 0.8
        }
        let offsetX: CGFloat = switch bottleShape {
        case .bead:
            0
        case .heart:
            viewType == .decoration ? .screenWidth * 0.21 * 0.7 : .screenWidth * 0.21
        case .default:
            viewType == .decoration ? .screenWidth * 0.21 * 0.6 : .screenWidth * 0.21 * 0.8
        }
        return CGPoint(
            x: offsetX,
            y: offsetY
        )
    }
    
    private let onTapGesture: (() -> Void)?
    
    @Binding private var starBottleAction: StarBottleAction
    
    @State private var starBottleScene: StarBottleScene
    @State private var records: [Record]
    
    @State var backgroundRewardData: Data = Data()
    @State private var backgroundImage: UIImage?
    @State var effectRewardData: Data?
    @State var decorationRewardName: String?
    @State var decorationRewardId: Int?
    @State var showsDefaultFortuneToby: Bool
    @State var bottleRewardId: Int?
    @State var bottleShape: BottleShape
    @State var bottleOffset: CGFloat = 0.0
    
    func fetchUI() {
        for i in 0..<records.count {
            starBottleScene.createInitStarNode(
                width: Self.width,
                height: Self.height,
                record: records[i],
                index: i
            )
        }
    }
    
    init(
        records: [Record],
        decorationData: DecorationData,
        viewType: StarBottleViewType = .default,
        starBottleAction: Binding<StarBottleAction> = .constant(.none),
        onTapGesture: (() -> Void)? = nil
    ) {
        self.records = records
        self.viewType = viewType
        self._starBottleAction = starBottleAction
        self.starBottleScene = StarBottleScene(
            size: .init(
                width: Self.width,
                height: Self.height
            ),
            bottleShape: decorationData.bottleShape
        )
        let backgroundRewardData = decorationData.backgroundRewardData ?? Data()
        self.backgroundRewardData = backgroundRewardData
        self.backgroundImage = UIImage(data: backgroundRewardData)
        self.effectRewardData = decorationData.effectRewardData
        self.decorationRewardName = decorationData.decorationRewardName
        self.decorationRewardId = decorationData.decorationRewardId
        self.showsDefaultFortuneToby = decorationData.showsDefaultFortuneToby
        self.bottleRewardId = decorationData.bottleRewardId
        self.bottleShape = decorationData.bottleShape
        
        self.onTapGesture = onTapGesture
    }

    @ViewBuilder
    private var decorationOverlay: some View {
        if let decorationRewardId {
            if decorationRewardId == 23 {
                spaceTobyView
            } else {
                lottieDecorationView(decorationRewardId: decorationRewardId)
            }
        } else if showsDefaultFortuneToby {
            defaultFortuneTobyView
        }
    }

    private var defaultFortuneTobyView: some View {
        VStack {
            HStack {
                DImage(DImageAsset.fortuneToby)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: viewType == .decoration ? Self.width * 0.24 : Self.width * 0.28)
                Spacer()
            }
            Spacer()
        }
        .allowsHitTesting(false)
        .offset(
            x: viewType == .decoration ? -(Self.width / 5.5) : -(Self.width / 12),
            y: viewType == .decoration ? -(Self.width / 14) : -(Self.width / 5)
        )
    }

    private var spaceTobyView: some View {
        VStack {
            HStack {
                DImage(DImageAsset.rewardDecorationSpaceVacance)
                    .resizable()
                    .aspectRatio(0.67, contentMode: .fit)
                    .frame(height: .screenWidth * 0.27)
                    .offset(
                        x: spaceVacanceItemOffset.x,
                        y: spaceVacanceItemOffset.y
                    )
            }
            Spacer()
        }
    }

    @ViewBuilder
    private func lottieDecorationView(decorationRewardId: Int) -> some View {
        if decorationRewardId == 20, let decorationRewardName { // 둥둥배
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DLottieView(
                        name: decorationRewardName,
                        loopMode: .loop
                    )
                    .frame(width: 80, height: 80)
                }
            }
            .allowsHitTesting(false)
            .offset(
                x: viewType == .decoration ? (Self.width / 6) : 0,
                y: viewType == .decoration ? -((.screenWidth / 3 - .defaultLayoutPadding) + (Self.width / 10)) : (Self.width / 8)
            )
        } else if let decorationRewardName { // 토비호, 몽글몽글 열기구, 달베개
            VStack {
                HStack {
                    DLottieView(
                        name: decorationRewardName,
                        loopMode: .loop
                    )
                    .frame(width: 80, height: 80)
                    Spacer()
                }
                Spacer()
            }
            .allowsHitTesting(false)
            .offset(
                x: viewType == .decoration ? -(Self.width / 5) : -(Self.width / 10),
                y: viewType == .decoration ? -(Self.width / 10) : -(Self.width / 5)
            )
        }
    }
    
    var body: some View {
        ZStack {
            if let image = backgroundImage {
                Image(uiImage: image)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .padding(-5)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            } else {
                BackgroundView(colors: [
                    ColorPalette.Semantic.backgroundTop,
                    ColorPalette.Semantic.backgroundBottom,
                ])
                DImage(DImageAsset.backgroundStar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
            }
            
            if let effectRewardData {
                GeometryReader { proxy in
                    DLottieView(
                        data: effectRewardData,
                        loopMode: .loop
                    )
                    .frame(
                        width: proxy.size.width,
                        height: .screenHeight
                    )
                    .ignoresSafeArea()
                }
                .allowsHitTesting(false)
            }
            VStack {
                Spacer()
                ZStack {
                    DImage(DImageAsset.starBottleBackground)
                        .resizable()
                        .frame(width: width + 20)
                        .aspectRatio(0.8, contentMode: .fit)
                    
                    SpriteView(
                        scene: starBottleScene,
                        options: [
                            .allowsTransparency,
                            .ignoresSiblingOrder,
                        ]
                    )
                    .frame(width: width, height: height)
                    
                    if let bottleRewardId {
                        RewardResourceMapper(
                            id: bottleRewardId,
                            category: .bottle
                        )
                        .image()
                        .resizable()
                        .aspectRatio(0.8, contentMode: .fit)
                        .frame(width: width)
                        .onTapGesture {
                            onTapGesture?()
                        }
                    } else {
                        DImage(DImageAsset.starBottleLock)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 38)
                    }
                }
                .offset(y: bottleOffset)
                .overlay {
                    decorationOverlay
                    .frame(width: width)
                }
                .padding(.bottom, viewType == .decoration ? 70 : (70 + 52 + .s5))
            }
        }
        .onAppear {
            fetchUI()
            motionManager.startGyros { dx, dy in
                starBottleScene.setGravity(dx: dx, dy: -dy)
            }
        }
        .onChange(of: starBottleAction) { (_, action) in
            switch action {
            case .addNewStar(let record):
                Task { @MainActor in
                    try await Task.sleep(nanoseconds: .nanosecondsPerSecond / 10)
                    starBottleScene.createNewStarNode(
                        width: Self.width,
                        height: Self.height,
                        record: record
                    )
                    bottleOffset = -20
                    try await Task.sleep(nanoseconds: 100_000)
                    withAnimation(.spring(duration: 1, bounce: 0.7)) {
                      bottleOffset = 0
                    }
                }
                
            case .changeRewardItem(let itemData):
                backgroundRewardData = itemData.backgroundItem ?? Data()
                effectRewardData = itemData.effectItem
                decorationRewardId = itemData.decorationItemId
                decorationRewardName = itemData.decorationItemName
                showsDefaultFortuneToby = itemData.decorationItemId == nil
                if let bottleItemId = itemData.bottleItemId,
                   let bottleShape = itemData.bottleShape {
                    bottleRewardId = bottleItemId
                    self.bottleShape = bottleShape
                }
                
            case .changeBackgroundItem(let data):
                backgroundRewardData = data
            case .changeEffectItem(let data):
                effectRewardData = data
            case .changeDecorationItem(let id, let name):
                decorationRewardId = id
                decorationRewardName = name
                showsDefaultFortuneToby = id == nil
            case .changeBottleItem(let id, let bottleShape):
                bottleRewardId = id
                self.bottleShape = bottleShape
            case .none:
                break
            }
        }
        .onChange(of: bottleShape) { _, newValue in
            starBottleScene.nodeSet.removeAll()
            starBottleScene.removeAllChildren()
            starBottleScene.bottleShape = newValue
            starBottleScene.addGroundNodeWithStarBottleShape(
                width: Self.width,
                height: Self.height,
                shape: newValue
            )
            (0..<records.count).forEach { i in
                starBottleScene.createInitStarNode(
                    width: Self.width,
                    height: Self.height,
                    record: records[i],
                    index: i
                )
            }
        }
        .onChange(of: backgroundRewardData) { _, newValue in
            backgroundImage = UIImage(data: newValue)
        }
    }
}
