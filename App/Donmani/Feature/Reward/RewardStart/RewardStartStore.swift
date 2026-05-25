//
//  RewardStartStore.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import UIKit
import ComposableArchitecture
import Lottie
import DNetwork

@Reducer
struct RewardStartStore {
    struct Context {
        let recordCount: Int
        let isNotOpened: Bool
        let userName: String
        let hasTodayRecord: Bool
        let hasYesterdayRecord: Bool
        
        init(
            recordCount: Int,
            isNotOpened: Bool,
            userName: String,
            hasTodayRecord: Bool,
            hasYesterdayRecord: Bool
        ) {
            self.recordCount = recordCount
            self.isNotOpened = isNotOpened
            self.userName = userName
            self.hasTodayRecord = hasTodayRecord
            self.hasYesterdayRecord = hasYesterdayRecord
        }
    }
    
    @ObservableState
    struct State {
        let recordCount: Int
        let userName: String
        
        var title: String = "앗! 아직 기록을 작성하지 않았어요"
        var subTitle: String = "오늘부터 기록하고 숨겨진 12개 선물을 받아 보세요!"
        var buttonTitle: String = "기록하러 가기"
        
        var isFullReward = false
        var isEnabledButton = true
        var isPresentingGuideText: Bool = false
        var isPresentingGuideBottomSheet: Bool = false
        var enabledWriteRecord = false
        
        var lastRecordCategory: RecordCategory = .flex
        
        var feedbackCard: FeedbackCard?
        var dayTitle = "요즘"
        
        var isPresentingFeedbackStartView: Bool = true
        var isPresentingFeedbackTitle: Bool = false
        var isPresentingFeedbackCard: Bool = false
        var isPresentingButton: Bool = true
        var webURLString: String?
        
        let lottieAnimation = LottieAnimation.named(
            "lottie_reward_start_bottom_sheet",
            bundle: .designSystem
        )
        
        init(context: Context) {
            self.recordCount = context.recordCount
            self.userName = context.userName
            
            if (context.recordCount >= 12) {
                if (context.isNotOpened) {
                    title = "기록하고 토비 선물받기 🎁\n지금까지 \(context.recordCount)번 기록 중"
                    subTitle = "12번 기록하면 특별한 선물을 받아요"
                    buttonTitle = "지금 선물받기"
                } else {
                    title = "준비한 선물을 모두 받았어요!\n이번 선물 어떠셨나요?"
                    subTitle = "다섯 분을 선정해 스타벅스 기프티콘을 드려요"
                    isFullReward = true
                    isEnabledButton = false
                }
            } else if context.recordCount > 0 {
                title = "기록하고 토비 선물받기 🎁\n지금까지 \(context.recordCount)번 기록 중"
                subTitle = "12번 기록하면 특별한 선물을 받아요"
                buttonTitle = "지금 선물받기"
                if (!context.isNotOpened) {
                    if (context.hasTodayRecord && context.hasYesterdayRecord) {
                        title = "오늘까지 받을 수 있는 선물을\n모두 받았어요"
                        isEnabledButton = false
                    } else {
//                        title = "앗! 아직 기록을 작성하지 않았어요"
//                        subTitle = "오늘부터 기록하고 숨겨진 12개 선물을 받아 보세요!"
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
            case pushDecorationView([Record], [RewardItemCategory: [Reward]], [Reward], RewardItemCategory)
        }
    }
    
    @Dependency(\.recordRepository) var recordRepository
    @Dependency(\.rewardRepository) var rewardRepository
    @Dependency(\.feedbackRepository) var feedbackRepository
    @Dependency(\.settings) var settings
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .toggleGuideBottomSheet:
                if settings.shouldShowRewardEventBottomSheet {
                    settings.shouldShowRewardEventBottomSheet = false
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
                            let count = try await rewardRepository.getNotOpenRewardCount()
                            await send(.delegate(.pushRewardReceiveView(count)))
                        }
                    }
                }
                
            case .touchReviewButton:
                state.webURLString = DURL.rewardFeedback.urlString
                
            case .touchDecorationButton:
                GA.Click(event: .customizeRewardButton).send()
                return .run { send in
                    let today: Day = .today
                    async let decorationItemTask = rewardRepository.getUserRewardItem()
                    async let currentDecorationItemTask = rewardRepository.getMonthlyRewardItem(year: today.year, month: today.month)
                    async let recordsTask = recordRepository.loadRecords(year: today.year, month: today.month)
                    let (decorationItem, currentDecorationItem, records) = try await (decorationItemTask, currentDecorationItemTask, recordsTask)
                    rewardRepository.saveRewards(items: decorationItem)
                    await send(.delegate(.pushDecorationView(records ?? [], decorationItem, currentDecorationItem, .background)))
                }
                
            case .requestFeedbackCard:
                return .run { send in
                    try await Task.sleep(nanoseconds: .nanosecondsPerSecond / 2)
                    let feedbackCard = try await feedbackRepository.getFeedbackCard()
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
