//
//  RecordCountSummary.swift
//  Donmani
//
//  Created by 문종식 on 4/17/25.
//

public struct RecordCountSummary {
    public let year: Int
    public let monthlyRecords: [Int: RecordCountSummary.Month]
    
    public init(year: Int, monthlyRecords: [Int: RecordCountSummary.Month]) {
        self.year = year
        self.monthlyRecords = monthlyRecords
    }
    
    public struct Month {
        public let recordCount: Int
        public let totalDaysInMonth: Int
        
        public init(recordCount: Int, totalDaysInMonth: Int) {
            self.recordCount = recordCount
            self.totalDaysInMonth = totalDaysInMonth
        }
    }
}
