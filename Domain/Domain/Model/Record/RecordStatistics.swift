//
//  RecordStatistics.swift
//  Donmani
//
//  Created by 문종식 on 4/15/25.
//

public struct RecordStatistics {
    public let year: Int
    public let month: Int
    public let goodCount: Int
    public let badCount: Int
    public let hasRecords: Bool
    public let records: [Record]?
    
    public init(year: Int, month: Int, goodCount: Int, badCount: Int, hasRecords: Bool, records: [Record]?) {
        self.year = year
        self.month = month
        self.goodCount = goodCount
        self.badCount = badCount
        self.hasRecords = hasRecords
        self.records = records
    }
}
