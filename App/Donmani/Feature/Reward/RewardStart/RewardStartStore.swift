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
        var subtitle: String = "오늘부터 기록하고 숨겨진 14개 선물을 받아 보세요!"
        var buttonTitle: String = "기록하러 가기"
        
        var isFullReward = false
        var isEnabledButton = true
        var isPresentingGuideText: Bool = false
        var isPresentingGuideBottomSheet: Bool = false
        
        var lastRecordCategory: RecordCategory = .init(GoodCategory.flex)
        
        var feedbackCard: FeedbackCard?
        var dayTitle = "요즘"
        
        var isPresentingFeedbackStartView: Bool = true
        var isPresentingFeedbackTitle: Bool = false
        var isPresentingFeedbackCard: Bool = false
        var isPresentingButton: Bool = true
        
        let lottieAnimation = LottieAnimation.named(
            "lottie_reward_start_bottom_sheet",
            bundle: .designSystem
        )
        
        init(context: Context) {
            self.recordCount = context.recordCount
            self.userName = DataStorage.getUserName()
            
            if (context.recordCount == 14) {
                title = "준비한 선물을 모두 받았어요!\n이번 선물 어떠셨나요?"
                subtitle = "다섯 분을 선정해 스타벅스 기프티콘을 드려요!"
                isFullReward = true
            } else if context.recordCount > 0 {
                title = "기록하고 토비 선물받기 🎁\n지금까지 \(context.recordCount)번 기록 중"
                subtitle = "14번 기록하면 특별한 선물을 받아요"
                buttonTitle = "지금 선물받기"
                if (!context.isNotOpened) {
                    title = "오늘까지 받을 수 있는 선물을\n모두 받았어요"
                    isEnabledButton = false
                }
            }

        }
    }
    
    enum Action {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        
        case touchNextButton
        case touchReviewButton
        
        case requestFeedbackCard
        case receivedFeedbackCard(FeedbackCard)
        
        case presentFeedbackTitle
        case presentFeedbackCard
        case presentNextButton
        
        case delegate(Delegate)
        enum Delegate {
            case pushRewardReceiveView(Int)
            case pushRecordEntryPointView
        }
    }
    
    var body: some ReducerOf<Self> {
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
                if (state.recordCount > 0 && state.isEnabledButton) {
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
                if state.recordCount.isZero {
                    return .run { send in
                        await send(.delegate(.pushRecordEntryPointView))
                    }
                } else {
                    if state.feedbackCard == nil {
                        return .run { send in
                            await send(.requestFeedbackCard)
                        }
                    } else {
                        UINavigationController.isBlockSwipe = true
                        return .run { send in
                            let count = try await NetworkService.DReward().fetchRewardNotOpenCount()
                            await send(.delegate(.pushRewardReceiveView(count)))
                        }
                    }
                }
                
            case .touchReviewButton:
                return .run { send in
                    let urlString = "__REDACTED_REWARD_FEEDBACK_URL__"
                    guard let url = URL(string: urlString) else {
                        return
                    }
                    await UIApplication.shared.open(url)
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
