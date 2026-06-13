//
//  RewardDataSource.swift
//  Donmani
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

final class DefaultRewardDataSource: RewardDataSource {
    private typealias _Year = Int
    private typealias _Month = Int
    private typealias _EquippedItem = [RewardItemCategory: Reward]
    private typealias _MonthlyEquippedItem = [_Month: _EquippedItem]
    
    private var yearlyEquippedItem: [_Year: _MonthlyEquippedItem]
    private var userRewardInventory: [RewardItemCategory: [Reward]]
    
    init() {
        self.yearlyEquippedItem = [:]
        self.userRewardInventory = [:]
    }
    
    func saveEquippedItems(year: Int, month: Int, items: [Reward]) {
        items.forEach { reward in
            yearlyEquippedItem
                .self[year, default: _MonthlyEquippedItem()]
                .self[month, default: _EquippedItem()]
                .self[reward.category] = reward
        }
    }
    
    func loadEquippedItems(year: Int, month: Int) -> [RewardItemCategory: Reward] {
        guard let monthlyEquippedItem = yearlyEquippedItem[year] else { return [:] }
        guard let equippedItems = monthlyEquippedItem[month] else { return [:] }
        return equippedItems
    }
    
    func saveReward(item: Reward) {
        userRewardInventory[item.category, default: []].append(item)
    }
    
    func saveRewards(items: [Reward]) {
        items.forEach { saveReward(item: $0) }
    }
    
    func loadReward(category: RewardItemCategory, id: Int) -> Reward? {
        guard let rewards = userRewardInventory[category] else { return nil }
        return rewards.first { $0.id == id }
    }
    
    func initRewardInventory() {
        userRewardInventory = [:]
    }
}
