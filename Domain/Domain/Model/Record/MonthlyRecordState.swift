//
//  MonthlyRecordState.swift
//  Donmani
//
//  Created by 문종식 on 7/29/25.
//

public struct MonthlyRecordState {
    public let records: [Record]?
    public let saveItems: [Reward]
    public let hasNotOpenedRewards: Bool
    public let totalExpensesCount: Int
    
    public init(
        records: [Record]?,
        saveItems: [Reward],
        hasNotOpenedRewards: Bool,
        totalExpensesCount: Int
    ) {
        self.records = records
        self.saveItems = saveItems
        self.hasNotOpenedRewards = hasNotOpenedRewards
        self.totalExpensesCount = totalExpensesCount
    }
    
    public var decorationItem: [RewardItemCategory: Reward] {
        saveItems.reduce(into: [RewardItemCategory: Reward]()) { result, reward in
            result[reward.category] = reward
        }
    }
}
