//
//  DefaultRecordDataSource.swift
//  Persistence
//
//  Created by 문종식 on 2/16/25.
//

import Domain

final class DefaultRecordDataSource: RecordDataSource {
    private typealias MonthlyRecord = [Int: [Record]]
    private var data: [Int: MonthlyRecord] = [:]

    init() {
        self.data = [:]
    }

    func save(_ record: Record) {
        let year = record.day.year
        let month = record.day.month
        data[year, default: MonthlyRecord()][month, default: []].append(record)
    }

    func load(year: Int, month: Int, day: Int) -> Record? {
        guard let yearlyRecord = data[year] else { return nil }
        guard let monthRecords = yearlyRecord[month] else { return nil }
        return monthRecords.first { $0.day == Day(year: year, month: month, day: day) }
    }

    func loadRecords(year: Int, month: Int) -> [Record]? {
        guard let yearRecords = data[year] else { return nil }
        guard let monthRecords = yearRecords[month] else { return nil }
        return monthRecords
    }
}
