//
//  RewardStartStore.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import UIKit
import ComposableArchitecture
import Lottie

@Reducer
struct RewardStartStore {
    struct Context {
        let recordCount: Int
        let isNotOpened: Bool
//        let isFirstOpened: Bool
        
        init(
            recordCount: Int,
            isNotOpened: Bool
//            isFirstOpened: Bool
        ) {
            self.recordCount = recordCount
            self.isNotOpened = isNotOpened
//            self.isFirstOpened = isFirstOpened
        }
    }
    
    @ObservableState
    struct State {
        let recordCount: Int
        let userName: String
        
        var title: String = "앗! 아직 기록을 작성하지 않았어요"
        var subtitle: String = "오늘부터 기록하고 숨겨진 12개 선물을 받아 보세요!"
        var buttonTitle: String = "기록하러 가기"
        
        var isFullReward = false
        var isEnabledButton = true
        var isPresentingGuideText: Bool = false
        var isPresentingGuideBottomSheet: Bool = false
        var enabledWriteRecord = false
        
        var lastRecordCategory: RecordCategory = .init(GoodCategory.flex)
        
        var feedbackCard: FeedbackCard?
        var dayTitle = "요즘"
        
        var isPresentingFeedbackStartView: Bool = true
        var isPresentingFeedbackTitle: Bool = false
        var isPresentingFeedbackCard: Bool = false
        var isPresentingButton: Bool = true
        var isPresentingRewardFeedbackView: Bool = false
        
        let lottieAnimation = LottieAnimation.named(
            "lottie_reward_start_bottom_sheet",
            bundle: .designSystem
        )
        
        init(context: Context) {
            self.recordCount = context.recordCount
            self.userName = DataStorage.getUserName()
            
            if (context.recordCount >= 12) {
                if (context.isNotOpened) {
                    title = "기록하고 토비 선물받기 🎁\n지금까지 \(context.recordCount)번 기록 중"
                    subtitle = "12번 기록하면 특별한 선물을 받아요"
                    buttonTitle = "지금 선물받기"
                } else {
                    title = "준비한 선물을 모두 받았어요!\n이번 선물 어떠셨나요?"
                    subtitle = "다섯 분을 선정해 스타벅스 기프티콘을 드려요"
                    isFullReward = true
                    isEnabledButton = false
                }
            } else if context.recordCount > 0 {
                title = "기록하고 토비 선물받기 🎁\n지금까지 \(context.recordCount)번 기록 중"
                subtitle = "12번 기록하면 특별한 선물을 받아요"
                buttonTitle = "지금 선물받기"
                if (!context.isNotOpened) {
                    let recordState = HistoryStateManager.shared.getState()
                    if (recordState[.today, default: true] && recordState[.yesterday, default: true]) {
                        title = "오늘까지 받을 수 있는 선물을\n모두 받았어요"
                        isEnabledButton = false
                    } else {
                        title = "앗! 아직 기록을 작성하지 않았어요"
                        subtitle = "오늘부터 기록하고 숨겨진 12개 선물을 받아 보세요!"
                        buttonTitle = "기록하러 가기"
                        enabledWriteRecord = true
                    }
                }
            } else {
                enabledWriteRecord = true
            }
        }
    }
    
    enum Action: BindableAction {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        
        case touchNextButton
        case touchReviewButton
        case touchDecorationButton
        
        case requestFeedbackCard
        case receivedFeedbackCard(FeedbackCard)
        
        case presentFeedbackTitle
        case presentFeedbackCard
        case presentNextButton
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate {
            case pushRewardReceiveView(Int)
            case pushRecordEntryPointView
            case pushDecorationView([RewardItemCategory: [Reward]], [Reward], RewardItemCategory)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .toggleGuideBottomSheet:
                if HistoryStateManager.shared.getIsFirstRewardEnter() {
                    HistoryStateManager.shared.setIsFirstRewardEnter()
                    state.isPresentingGuideBottomSheet = !state.isPresentingGuideBottomSheet
                    if !state.isPresentingGuideBottomSheet {
                        UINavigationController.isBlockSwipe = false
                    }
                }
                
            case .touchGuideBottomSheetButton:
                if (state.recordCount > 0 && state.isEnabledButton && !state.enabledWriteRecord) {
                    return .run { send in
                        await send(.toggleGuideBottomSheet)
                        await send(.requestFeedbackCard)
                    }
                } else {
                    return .run { send in
                        await send(.toggleGuideBottomSheet)
                    }
                }
            
            case .touchNextButton:
                if state.enabledWriteRecord {
                    return .run { send in
                        await send(.delegate(.pushRecordEntryPointView))
                    }
                } else {
                    if state.feedbackCard == nil {
                        GA.Click(event: .rewardButton).send()
                        return .run { send in
                            await send(.requestFeedbackCard)
                        }
                    } else {
                        GA.Click(event: .rewardFeedbackButton).send()
                        UINavigationController.isBlockSwipe = true
                        return .run { send in
                            let count = try await NetworkService.DReward().fetchRewardNotOpenCount()
                            await send(.delegate(.pushRewardReceiveView(count)))
                        }
                    }
                }
                
            case .touchReviewButton:
                state.isPresentingRewardFeedbackView = true
//                return .run { send in
//                    let urlString = "__REDACTED_REWARD_FEEDBACK_URL__"
//                    guard let url = URL(string: urlString) else {
//                        return
//                    }
//                    await UIApplication.shared.open(url)
//                }
                
            case .touchDecorationButton:
                GA.Click(event: .customizeRewardButton).send()
                return .run { send in
                    let dto = try await NetworkService.DReward().reqeustRewardItem()
                    var decorationItem = NetworkDTOMapper.mapper(dto: dto)
                    for reward in (decorationItem[.effect] ?? []) {
                        if let effect = DownloadManager.Effect(rawValue: reward.id),
                           let contentUrl = reward.jsonUrl {
                            let data = try await NetworkService.DReward().downloadData(from: contentUrl)
                            let name = RewardResourceMapper(id: reward.id, category: .effect).resource()
                            try DataStorage.saveJsonFile(data: data, name: name)
                        }
                    }
                    DataStorage.setInventory(decorationItem)
                    let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
                    let year = Int(today[0]) ?? 2025
                    let month = Int(today[1]) ?? 6
                    decorationItem = DataStorage.getInventory()
                    let infoDto = try await NetworkService.DReward().reqeustDecorationInfo(year: year, month: month)
                    let currentDecorationItem = NetworkDTOMapper.mapper(dto: infoDto)
                    await send(.delegate(.pushDecorationView(decorationItem, currentDecorationItem, .background)))
                }
                
            case .requestFeedbackCard:
                return .run { send in
                    try await Task.sleep(nanoseconds: .nanosecondsPerSecond / 2)
                    guard let feedbackCardDTO = try? await NetworkService.DFeedback().receiveFeedbackCard() else {
                        return
                    }
                    let feedbackCard = NetworkDTOMapper.mapper(dto: feedbackCardDTO)
                    await send(.receivedFeedbackCard(feedbackCard))
                }
            case .receivedFeedbackCard(let feedbackCard):
                state.feedbackCard = feedbackCard
                state.isPresentingFeedbackStartView = false
                state.isPresentingButton = false
                state.dayTitle = feedbackCard.prefix
                return .run { send in
                    try await Task.sleep(for: .seconds(0.6))
                    await send(.presentFeedbackTitle)
                    try await Task.sleep(for: .seconds(0.5))
                    await send(.presentFeedbackCard)
                    try await Task.sleep(for: .seconds(0.5))
                    await send(.presentNextButton)
                }
                
            case .presentFeedbackTitle:
                state.isPresentingFeedbackTitle = true
                
            case .presentFeedbackCard:
                state.isPresentingFeedbackCard = true
                state.buttonTitle = "다음"
                
            case .presentNextButton:
                state.isPresentingButton = true
                
            default:
                break
            }
            return .none
        }
    }
}
