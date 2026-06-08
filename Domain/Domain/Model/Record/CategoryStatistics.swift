//
//  CategoryStatistics.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

public struct CategoryStatistics {
    public let year: Int
    public let month: Int
    public let categoryCounts: [RecordCategory: Int]
    
    public init(year: Int, month: Int, categoryCounts: [RecordCategory: Int]) {
        self.year = year
        self.month = month
        self.categoryCounts = categoryCounts
    }
}
