//
//  Record.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

public struct Record {
    public let day: Day
    public let records: [RecordContentType: RecordContent]
    
    public init(day: Day, records: [RecordContent]) {
        self.day = day
        self.records = records.reduce(into: [:]) { result, record in
            result[record.flag] = record
        }
    }
}

extension Record: Equatable {
    public static func == (lhs: Record, rhs: Record) -> Bool {
        lhs.day == rhs.day
    }
}

extension Record: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(day)
    }
}

extension Record: Identifiable {
    public var id: String {
        day.yyyyMMdd
    }
}
