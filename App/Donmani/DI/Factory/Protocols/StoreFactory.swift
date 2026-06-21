//
//  StoreFactory.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

protocol StoreFactory {
    func makeMainNavigationStore(state: MainNavigationStore.State) -> StoreOf<MainNavigationStore>
    func makeSettingStore(state: SettingStore.State) -> StoreOf<SettingStore>

    // Record
    func makeRecordEntryPointStore(state: RecordEntryPointStore.State) -> StoreOf<RecordEntryPointStore>
    func makeRecordWritingStore(state: RecordWritingStore.State) -> StoreOf<RecordWritingStore>

    // List
    func makeBottleCalendarStore(state: BottleCalendarStore.State) -> StoreOf<BottleCalendarStore>
    func makeMonthlyRecordListStore(state: RecordListStore.State) -> StoreOf<RecordListStore>
    func makeStatisticsStore(state: StatisticsStore.State) -> StoreOf<StatisticsStore>
    func makeMonthlyStarBottleStore(state: MonthlyStarBottleStore.State) -> StoreOf<MonthlyStarBottleStore>

    // Reward
    func makeRewardStartStore(state: RewardStartStore.State) -> StoreOf<RewardStartStore>
    func makeRewardReceiveStore(state: RewardReceiveStore.State) -> StoreOf<RewardReceiveStore>
    func makeDecorationStore(state: DecorationStore.State) -> StoreOf<DecorationStore>
}
