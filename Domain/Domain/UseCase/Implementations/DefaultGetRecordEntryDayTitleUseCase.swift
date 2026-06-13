//
//  DefaultGetRecordEntryDayTitleUseCase.swift
//  Domain
//
//  Created by 문종식 on 11/23/25.
//

struct DefaultGetRecordEntryDayTitleUseCase: GetRecordEntryDayTitleUseCase {
    private let recordRepository: RecordRepository

    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }

    func callAsFunction() -> RecordEntryDayTitle {
        let hasTodayRecord = recordRepository.load(date: .today) != nil
        let hasYesterdayRecord = recordRepository.load(date: .yesterday) != nil

        return switch (hasTodayRecord, hasYesterdayRecord) {
        case (false, false): .oneDay
        case (true, _): .yesterday
        default: .today
        }
    }
}
