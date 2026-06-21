//
//  RewardDataSource.swift
//  Persistence
//
//  Created by 문종식 on 8/2/25.
//

import Domain

public protocol RewardDataSource {
    func saveEquippedItems(year: Int, month: Int, items: [Reward])
    func loadEquippedItems(year: Int, month: Int) -> [RewardItemCategory: Reward]
    func saveReward(item: Reward)
    func saveRewards(items: [Reward])
    func initRewardInventory()
}
