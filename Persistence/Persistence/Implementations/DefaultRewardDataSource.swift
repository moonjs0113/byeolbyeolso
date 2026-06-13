//
//  DefaultRewardDataSource.swift
//  Persistence
//
//  Created by 문종식 on 8/2/25.
//

import Domain

final class DefaultRewardDataSource: RewardDataSource {
    private typealias Year = Int
    private typealias Month = Int
    private typealias EquippedItem = [RewardItemCategory: Reward]
    private typealias MonthlyEquippedItem = [Month: EquippedItem]

    private var yearlyEquippedItem: [Year: MonthlyEquippedItem]
    private var userRewardInventory: [RewardItemCategory: [Reward]]

    init() {
        self.yearlyEquippedItem = [:]
        self.userRewardInventory = [:]
    }

    func saveEquippedItems(year: Int, month: Int, items: [Reward]) {
        items.forEach { reward in
            yearlyEquippedItem
                .self[year, default: MonthlyEquippedItem()]
                .self[month, default: EquippedItem()]
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
