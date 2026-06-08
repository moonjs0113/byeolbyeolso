//
//  RewardRepository.swift
//  Domain
//
//  Created by 문종식 on 6/8/26.
//

public protocol RewardRepository {
    func saveEquippedItems(year: Int, month: Int, items: [Reward])
    func loadEquippedItems(year: Int, month: Int) -> [RewardItemCategory: Reward]
    func saveReward(item: Reward)
    func saveRewards(items: [RewardItemCategory: [Reward]])
    func saveRewards(items: [Reward])
    func getUserRewardItem() async throws -> [RewardItemCategory: [Reward]]
    func getNotOpenRewardCount() async throws -> Int
    func getMonthlyRewardItem(year: Int, month: Int) async throws -> [Reward]
    func putHiddenRead(year: Int, month: Int) async throws
    func putOpenReward() async throws -> [Reward]
    func putSaveReward(
        year: Int,
        month: Int,
        backgroundId: Int,
        effectId: Int,
        decorationId: Int,
        byeoltongCaseId: Int
    ) async throws
}
