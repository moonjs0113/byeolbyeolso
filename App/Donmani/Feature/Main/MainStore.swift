//
//  MainStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import UIKit
import ComposableArchitecture
import Core
import DesignSystem
import Domain

@Reducer
struct MainStore {
    struct Context {
        let records: [Record]
        let hasRecord: (today: Bool, yesterday: Bool)
        let isPresentingNewStarBottle: Bool
        let decorationData: DecorationData
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        var userName: String = ""
        var day: Day
        var records: [Record]
        var decorationData: DecorationData
        var dailyFortune: Fortune = .empty
        
        /// 기록 작성 가능 여부
        var canWriteRecord: Bool
        
        var isPresentingRecordYesterdayToolTip: Bool = false
        var isPresentingAlreadyWrite: Bool = false
        var isPresentingNewStarBottle: Bool = false
        var isPresentingRewardToolTipView: Bool = false
        var isPresentingTodayFortuneView: Bool = false
        var isNotificationEnabled: Bool = false
        var isRequestNotificationPermission: Bool = true
        var isPresentDailyFortuneModal: Bool = false
        var shouldPushRecordAfterFortuneConfirm: Bool = false
        var shouldWaitForHomeReturnAfterFortuneCompletion: Bool = false
        var isLoading: Bool = false
        var starBottleOpacity = 1.0
        var yOffset: CGFloat = 0
        var shakeCount = 0
        var isNewStar = 0
        var starBottleAction: StarBottleAction = .none
        var toastType: ToastType = .none
        
        init(context: MainStore.Context) {
            self.day = .today
            self.records = context.records
            self.decorationData = context.decorationData
            self.canWriteRecord = !(context.hasRecord.today && context.hasRecord.yesterday)
            self.isPresentingNewStarBottle = context.isPresentingNewStarBottle
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case refreshNotificationPermissionStatus
        case _updateNotificationPermissionStatus(Bool)
        case touchEnableNotificationButton
        case presentDailyFortune(FortuneReadSource, Bool)
        case _updateDailyFortune(Fortune)
        case completeDailyFortuneWithoutPresentation
        case fetchRewardItem(DecorationData)
        
        case closePopover
        case checkToolTip
        case dismissNewStarBottleView
        case dismissAlreadyWrite
        case shakeTwice
        case touchRewardButton
        
        case delegate(Delegate)
        
        case touchDailyFortuneConfirm
        case touchFortuneToby
        case touchTodayFortuneConfirm
        case completeDailyFortuneDismiss
        
        case updateRewardUI(RewardItemData)
        
        enum Delegate {
            case pushSettingView
            case pushRecordEntryPointView
            case pushRecordListView
            case pushBottleCalendarView([Int: RecordCountSummary])
            case pushFortuneView([Fortune])
            case pushRewardStartView
            case completeOnboardingEndHomeEvent(shouldContinueImmediately: Bool)
            case completeFortuneHomeEvent(shouldContinueImmediately: Bool)
            case completeNewStarBottleHomeEvent(shouldContinueImmediately: Bool)
        }
    }
    
    // MARK: - Dependency
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.canWriteRecordUseCase) var canWriteRecordUseCase
    @Dependency(\.recordRepository) var recordRepository
    @Dependency(\.fileRepository) var fileRepository
    @Dependency(\.rewardRepository) var rewardRepository
    @Dependency(\.fortuneRepository) var fortuneRepository
    @Dependency(\.settings) var settings
    let notificationManager = NotificationManager()
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                GA.View(event: .main).send()
                state.day = .today
                state.userName = userRepository.getUserName()
                state.canWriteRecord = canWriteRecordUseCase()
                state.isPresentingRewardToolTipView = settings.shouldShowRewardToolTip
                return .merge(
                    .send(.refreshNotificationPermissionStatus),
                    .run { send in
                        let day: Day = .today
                        let items = rewardRepository.loadEquippedItems(year: day.year, month: day.month)
                        let backgroundRewardData: Data? = items[.background].map { try? fileRepository.loadRewardData(from: $0, resourceType: .image) }
                        let effectRewardData: Data? = items[.effect].map { try? fileRepository.loadRewardData(from: $0, resourceType: .json) }
                        let decorationState = DecorationData.resolvedDecorationState(from: items[.decoration])
                        let bottleRewardId: Int? = items[.bottle].map { $0.id }
                        let bottleShape: BottleShape = bottleRewardId.map { BottleShape(id: $0) } ?? .default
                        let decorationData = DecorationData(
                            backgroundRewardData: backgroundRewardData,
                            effectRewardData: effectRewardData,
                            decorationRewardName: decorationState.decorationRewardName,
                            decorationRewardId: decorationState.decorationRewardId,
                            showsDefaultFortuneToby: decorationState.showsDefaultFortuneToby,
                            bottleRewardId: bottleRewardId,
                            bottleShape: bottleShape
                        )
                        await send(.fetchRewardItem(decorationData))
                        
                        let itemData = makeRewardItemData(items: items)
                        await send(.updateRewardUI(itemData))
                        
                        let hasTodayRecord = recordRepository.load(date: .today).isSome
                        let hasYesterdayRecord = recordRepository.load(date: .yesterday).isSome
                        if (hasTodayRecord && !hasYesterdayRecord) {
                            await send(.checkToolTip)
                        }
                    }
                )
                
            case .refreshNotificationPermissionStatus:
                return .run { send in
                    let status = await notificationManager.getNotificationPermissionStatus()
                    await send(._updateNotificationPermissionStatus(status == .authorized))
                }
                
            case ._updateNotificationPermissionStatus(let isEnabled):
                state.isNotificationEnabled = isEnabled
                
            case .presentDailyFortune(let readSource, let shouldPushRecordAfterFortuneConfirm):
                state.shouldPushRecordAfterFortuneConfirm = shouldPushRecordAfterFortuneConfirm
                state.shouldWaitForHomeReturnAfterFortuneCompletion = false
                return requestDailyFortuneEffect(readSource: readSource)
                
            case ._updateDailyFortune(let fortune):
                state.dailyFortune = fortune
                state.isPresentDailyFortuneModal = true
                settings.lastFortuneDay = Day.today.yyyyMMddCompact

            case .completeDailyFortuneWithoutPresentation:
                state.shouldPushRecordAfterFortuneConfirm = false
                state.shouldWaitForHomeReturnAfterFortuneCompletion = false
                return .send(.delegate(.completeFortuneHomeEvent(shouldContinueImmediately: true)))
                
            case .fetchRewardItem(let decorationData):
                state.decorationData = decorationData
                
            case .closePopover:
                state.isPresentingRecordYesterdayToolTip = false
                
            case .checkToolTip:
                state.isPresentingRecordYesterdayToolTip = true
                
            case .dismissNewStarBottleView:
                state.isPresentingNewStarBottle = false
                UINavigationController.isBlockSwipe = false
                return .merge(
                    .send(.delegate(.completeNewStarBottleHomeEvent(shouldContinueImmediately: false))),
                    .run { send in
                        async let year2025 = recordRepository.getYearlyRecordSummary(year: 2025)
                        async let year2026 = recordRepository.getYearlyRecordSummary(year: 2026)
                        let result = [
                            2025: try await year2025,
                            2026: try await year2026
                        ]
                        await send(.delegate(.pushBottleCalendarView(result)))
                    }
                )
                
            case .dismissAlreadyWrite:
                state.isPresentingAlreadyWrite = false
                return .send(.delegate(.completeOnboardingEndHomeEvent(shouldContinueImmediately: true)))
                
            case .shakeTwice:
                if state.shakeCount >= 6 {
                    state.shakeCount = 0
                    return .none
                }
                state.shakeCount += 1
                state.yOffset = state.shakeCount % 2 == 0 ? 10 : 0
                return .run { send in
                    try await Task.sleep(nanoseconds: .nanosecondsPerSecond / 2)
                    await send(.shakeTwice, animation: .linear(duration: 0.5))
                }
                
            case .touchRewardButton:
                GA.Click(event: .mainShopButton).send()
                if (state.isPresentingRewardToolTipView) {
                    state.isPresentingRewardToolTipView = false
                    settings.shouldShowRewardToolTip = false
                }
                return .run { send in
                    await send(.delegate(.pushRewardStartView))
                }
                
                // 화면 업데이트 Action
            case .updateRewardUI(let itemData):
                state.starBottleAction = .changeRewardItem(itemData)
                
            case .touchDailyFortuneConfirm:
                state.isPresentDailyFortuneModal = false
                settings.shouldPushRecordAfterFortuneConfirm = false
                if state.shouldPushRecordAfterFortuneConfirm {
                    state.shouldWaitForHomeReturnAfterFortuneCompletion = true
                    return .run { send in
                        await send(.delegate(.pushRecordEntryPointView))
                    }
                }
                
            case .touchTodayFortuneConfirm:
                state.isPresentingTodayFortuneView = false
                return .merge(
                    .send(.delegate(.completeFortuneHomeEvent(shouldContinueImmediately: false))),
                    requestWeeklyFortuneEffect()
                )
                
            case .touchFortuneToby:
                return requestWeeklyFortuneEffect()
                
            case .touchEnableNotificationButton:
                GA.Click(event: .settingNotice).send()
                return .run { _ in
                    await notificationManager.openAppNotificationSettings()
                }
                
            case .completeDailyFortuneDismiss:
                let shouldContinueImmediately = !state.shouldWaitForHomeReturnAfterFortuneCompletion
                state.shouldPushRecordAfterFortuneConfirm = false
                state.shouldWaitForHomeReturnAfterFortuneCompletion = false
                return .send(.delegate(.completeFortuneHomeEvent(shouldContinueImmediately: shouldContinueImmediately)))
                
            default:
                break
            }
            
            return .none
        }
    }
}

extension MainStore {
    func requestWeeklyFortuneEffect() -> Effect<MainStore.Action> {
        .run { send in
            let endDay: Day = .today
            let startDay = endDay.adding(day: -6) ?? endDay
            let fortunes = try await fortuneRepository.getFortunes(
                startDay: startDay,
                endDay: endDay
            )
            .sorted { $0.day < $1.day }
            await send(.delegate(.pushFortuneView(fortunes)))
        }
    }

    func requestDailyFortuneEffect(readSource: FortuneReadSource) -> Effect<MainStore.Action> {
        .run { send in
            do {
                let fortune = try await fortuneRepository.getTodayFortune()
                await send(._updateDailyFortune(fortune))
                try? await fortuneRepository.putFortuneRead(readSource: readSource)
            } catch {
                await send(.completeDailyFortuneWithoutPresentation)
            }
        }
    }
    
    func makeRewardItemData(items: [RewardItemCategory: Reward]) -> RewardItemData {
        var decorationItemId: Int? = nil
        var decorationItemName: String? = nil
        if items[.decoration]?.id != 3 {
            decorationItemId = items[.decoration].map(\.id)
            decorationItemName = items[.decoration].map { item in
                RewardResourceMapper(id: item.id, category: .decoration).resource()
            }
        }
        return RewardItemData(
            backgroundItem: items[.background].map { item in
                try? fileRepository.loadRewardData(from: item, resourceType: .image)
            },
            effectItem: items[.effect].map { item in
                try? fileRepository.loadRewardData(from: item, resourceType: .json)
            },
            decorationItemId: decorationItemId,
            decorationItemName: decorationItemName,
            bottleItemId: items[.bottle].map(\.id),
            bottleShape: items[.bottle].map { item in
                BottleShape(id: item.id)
            }
        )
    }
}
