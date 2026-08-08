//
//  MainNavigationStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import UIKit
import Networking
import ComposableArchitecture
import Core
import Domain

@Reducer
struct MainNavigationStore {
    enum HomeEvent {
        case onboardingEnd
        case notificationPermission
        case fortune
        case newStarBottle
    }
    
    @ObservableState
    struct State {
        var mainState: MainStore.State
        var path = StackState<MainNavigationStore.Path.State>()
        var currentHomeEvent: HomeEvent? = nil
        var shouldShowOnboardingEndHomeEvent: Bool
        var shouldShowNewStarBottleHomeEvent: Bool
        
        init(mainState: MainStore.State) {
            self.shouldShowOnboardingEndHomeEvent = mainState.isPresentingAlreadyWrite
            self.shouldShowNewStarBottleHomeEvent = mainState.isPresentingNewStarBottle
            var mainState = mainState
            mainState.isPresentingAlreadyWrite = false
            mainState.isPresentingNewStarBottle = false
            self.mainState = mainState
        }
    }
    
    enum Action {
        case mainAction(MainStore.Action)
        case path(StackActionOf<MainNavigationStore.Path>)
        
        case completeWriteRecordContent(RecordContent)
        case completeWriteRecord(Record)
        case _updateMainStatePresentingRewardToolTipFlag(Bool)
        
        case requestAppStoreReview
        case presentCancelBottom
        case receiveFortuneNotification
        case processHomeEvents
        case completeHomeEvent(shouldContinueImmediately: Bool)
        
        case push(Destination)
        enum Destination {
            case setting(String)
            case fortune(FortuneStore.Context)
            
            // Record
            case record(RecordEntryPointStore.Context)
            case recordWriting(RecordContentType, RecordContent?, String)
            
            // List
            case monthlyRecordList(Day, [Record], Bool)
            case bottleCalendar([Int: RecordCountSummary])
            case statistics(Day, [Record])
            case monthlyStarBottle(Day, [Record], [Reward])
            
            // Reward
            case rewardStart(FeedbackInfo, Bool, Bool) // Today, Yesterday
            case rewardReceive(Int)
            case decoration([Record], [RewardItemCategory : [Reward]], [Reward], RewardItemCategory, DecorationData)
        }
    }
    
    @Dependency(\.mainStateFactory) var stateFactory
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.recordRepository) var recordRepository
    @Dependency(\.rewardRepository) var rewardRepository
    @Dependency(\.feedbackRepository) var feedbackRepository
    @Dependency(\.fileRepository) var fileRepository
    @Dependency(\.settings) var settings
    @Dependency(\.getRecordEntryDayTitleUseCase) var getRecordEntryDayTitleUseCase
    
    var body: some ReducerOf<Self> {
        Scope(
            state: \.mainState,
            action: \.mainAction
        ) {
            MainStore()
        }
        
        Reduce { state, action in
            switch action {
            case .mainAction(.delegate(let mainAction)):
                switch mainAction {
                case .pushSettingView:
                    return .run { send in
                        let userName = userRepository.getUserName()
                        await send(.push(.setting(userName)))
                    }
                    
                case .pushRecordEntryPointView:
                    return .run { send in
                        let context = RecordEntryPointStore.Context(
                            recordEntryDayTitle: getRecordEntryDayTitleUseCase()
                        )
                        await send(.push(.record(context)))
                    }
                    
                case .pushRecordListView:
                    return .run { send in
                        let today: Day = .today
                        let monthlyRecordState = try await recordRepository.getMonthlyRecordList(
                            year: today.year,
                            month: today.month
                        )
                        let records = monthlyRecordState.records ?? []
                        await send(.push(.monthlyRecordList(.today, records, true)))
                    }
                    
                case .pushBottleCalendarView(let recordCountSummary):
                    return .run { send in
                        await send(.push(.bottleCalendar(recordCountSummary)))
                    }

                case .pushFortuneView(let fortunes):
                    return .run { send in
                        let context = FortuneStore.Context(
                            fortunes: fortunes,
                            referenceToday: .today,
                            referenceYesterday: .yesterday,
                            hasTodayRecord: recordRepository.load(date: .today).isSome,
                            hasYesterdayRecord: recordRepository.load(date: .yesterday).isSome
                        )
                        await send(.push(.fortune(context)))
                    }
                    
                case .pushRewardStartView:
                    return .run { send in
                        let feedbackInfo = try await feedbackRepository.getFeedbackState()
                        let hasTodayRecord = recordRepository.load(date: .today).isSome
                        let hasYesterdayRecord = recordRepository.load(date: .yesterday).isSome
                        await send(.push(.rewardStart(feedbackInfo, hasTodayRecord, hasYesterdayRecord)))
                    }

                case .completeOnboardingEndHomeEvent(let shouldContinueImmediately):
                    return .send(.completeHomeEvent(shouldContinueImmediately: shouldContinueImmediately))

                case .completeFortuneHomeEvent(let shouldContinueImmediately):
                    return .send(.completeHomeEvent(shouldContinueImmediately: shouldContinueImmediately))

                case .completeNewStarBottleHomeEvent(let shouldContinueImmediately):
                    return .send(.completeHomeEvent(shouldContinueImmediately: shouldContinueImmediately))
                }
                
            case .path(.element(let id, let action)):
                return path(id: id, action: action, &state)

            case .push(let destination):
                return push(to: destination, &state)
                
            case .completeWriteRecordContent(let recordContent):
                UINavigationController.isBlockSwipe = true
                if let recordWritingID = state.path.ids.last {
                    state.path.pop(from: recordWritingID)
                }
                if let recordID = state.path.ids.last {
                    if case var .record(recordState) = state.path[id: recordID] {
                        recordState.updateRecordContent(content: recordContent)
                        state.path[id: recordID] = .record(recordState)
                    }
                }
                
            case .completeWriteRecord(let record):
                UINavigationController.isBlockSwipe = false
                state.path.removeAll()
                var mainState = state.mainState
                mainState.records.append(record)
                let hasTodayRecord = recordRepository.load(date: .today).isSome
                let hasYesterdayRecord = recordRepository.load(date: .yesterday).isSome
                mainState.canWriteRecord = !(hasTodayRecord && hasYesterdayRecord)
                mainState.isNewStar += 1
                mainState.starBottleAction = .addNewStar(record)
                state.mainState = mainState
                return .run { send in
                    let items = try await rewardRepository.getUserRewardItem()
                    let itemCount = items.reduce(into: 0) { result, items in
                        result += items.value.count
                    }
                    await send(._updateMainStatePresentingRewardToolTipFlag(!(itemCount>15)))
                }
                
            case ._updateMainStatePresentingRewardToolTipFlag(let flag):
                var mainState = state.mainState
                mainState.isPresentingRewardToolTipView = flag
                state.mainState = mainState
                
            case .requestAppStoreReview:
                return .run { _ in
                    await requestAppStoreReview()
                }

            case .processHomeEvents:
                guard state.path.ids.isEmpty, state.currentHomeEvent == nil else {
                    return .none
                }
                state.mainState.starBottleOpacity = 1.0

                if state.shouldShowOnboardingEndHomeEvent {
                    state.shouldShowOnboardingEndHomeEvent = false
                    state.currentHomeEvent = .onboardingEnd
                    state.mainState.isPresentingAlreadyWrite = true
                    return .none
                }

                if settings.shouldShowRequestNotificationPermission {
                    state.currentHomeEvent = .notificationPermission
                    settings.shouldShowRequestNotificationPermission = false
                    return .run { send in
                        await NotificationManager().checkNotificationPermission()
                        await send(.completeHomeEvent(shouldContinueImmediately: true))
                    }
                }

                if settings.shouldShowInitialFortuneModal || settings.shouldShowFortuneByNotification {
                    state.currentHomeEvent = .fortune

                    if settings.shouldShowInitialFortuneModal {
                        settings.shouldShowInitialFortuneModal = false
                        settings.shouldShowFortuneByNotification = false
                        settings.shouldPushRecordAfterFortuneConfirm = false
                        state.mainState.shouldPushRecordAfterFortuneConfirm = false
                        state.mainState.isPresentingTodayFortuneView = true
                        return .none
                    }

                    let shouldPushRecordAfterFortuneConfirm = settings.shouldPushRecordAfterFortuneConfirm
                    settings.shouldShowFortuneByNotification = false
                    settings.shouldPushRecordAfterFortuneConfirm = false
                    return .send(
                        .mainAction(
                            .presentDailyFortune(
                                .notification,
                                shouldPushRecordAfterFortuneConfirm
                            )
                        )
                    )
                }

                if state.shouldShowNewStarBottleHomeEvent {
                    state.shouldShowNewStarBottleHomeEvent = false
                    state.currentHomeEvent = .newStarBottle
                    state.mainState.isPresentingNewStarBottle = true
                    return .none
                }
                return .none
                
            case .completeHomeEvent(let shouldContinueImmediately):
                state.currentHomeEvent = nil
                if shouldContinueImmediately {
                    return .send(.processHomeEvents)
                }
                return .none
                
            case .presentCancelBottom:
                if let lastElementID = state.path.ids.last {
                    if let pathCase = state.path[id: lastElementID] {
                        switch pathCase {
                        case .record(var childState):
                            childState.isPresentingCancel = true
                            state.path[id: lastElementID] = .record(childState)
                            
                        case .recordWriting(var childState):
                            childState.isPresentingCancel = true
                            state.path[id: lastElementID] = .recordWriting(childState)
                        default:
                            break
                        }
                    }
                }

            case .receiveFortuneNotification:
                state.path.removeAll()
                return .send(.processHomeEvents)
                
            default:
                break
            }
            return .none
        }
        .forEach(\.path, action: \.path)
    }
}

extension MainNavigationStore {
    @Reducer
    enum Path {
        // Record
        case record(RecordEntryPointStore)
        case recordWriting(RecordWritingStore)
        
        // List
        case monthlyRecordList(RecordListStore)
        case bottleCalendar(BottleCalendarStore)
        case statistics(StatisticsStore)
        case monthlyStarBottle(MonthlyStarBottleStore)
        case fortune(FortuneStore)
        
        // Reward
        case rewardStart(RewardStartStore)
        case rewardReceive(RewardReceiveStore)
        case decoration(DecorationStore)
        
        case setting(SettingStore)
    }
}
