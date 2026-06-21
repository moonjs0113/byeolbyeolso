//
//  DefaultCanWriteRecordUseCase.swift
//  Domain
//
//  Created by 문종식 on 8/16/25.
//

struct DefaultCanWriteRecordUseCase: CanWriteRecordUseCase {
    private let recordRepository: RecordRepository

    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }

    private func hasRecord(on day: Day) -> Bool {
        recordRepository.load(date: day) != nil
    }

    func callAsFunction() -> Bool {
        !(hasRecord(on: .today) && hasRecord(on: .yesterday))
    }
}
