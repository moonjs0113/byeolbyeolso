//
//  StateFactory.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import Domain

protocol StateFactory {
    func makeMainNavigationState(mainState: MainStore.State) -> MainNavigationStore.State
    func makeMainState(context: MainStore.Context) -> MainStore.State
    func makeSettingState(context: SettingStore.Context) -> SettingStore.State

    // Record
    func makeRecordEntryPointState(context: RecordEntryPointStore.Context) -> RecordEntryPointStore.State
    func makeRecordWritingState(context: RecordWritingStore.Context) -> RecordWritingStore.State

    // List
    func makeBottleCalendarState(context: [Int: RecordCountSummary]) -> BottleCalendarStore.State
    func makeMonthlyRecordListState(context: RecordListStore.Context) -> RecordListStore.State
    func makeStatisticsState(context: StatisticsStore.Context) -> StatisticsStore.State
    func makeMonthlyStarBottleState(context: MonthlyStarBottleStore.Context) -> MonthlyStarBottleStore.State

    // Reward
    func makeRewardStartState(context: RewardStartStore.Context) -> RewardStartStore.State
    func makeRewardReceiveState(context: RewardReceiveStore.Context) -> RewardReceiveStore.State
    func makeDecorationState(context: DecorationStore.Context) -> DecorationStore.State
}
