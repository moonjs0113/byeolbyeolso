//
//  GetRecordDayTitleUseCase.swift
//  Donmani
//
//  Created by 문종식 on 11/23/25.
//

import ComposableArchitecture

protocol GetRecordEntryContextUseCase {
    var context: RecordEntryPointStore.Context { get }
//    var dayTitle: String { get }
//    var dayType: Day { get }
//    var isDayToggleEnabled: Bool { get }
}

struct DefaultGetRecordEntryContextUseCase {
    let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
}

extension DefaultGetRecordEntryContextUseCase: GetRecordEntryContextUseCase {
    var context: RecordEntryPointStore.Context {
        let hasTodayRecord = recordRepository.load(date: .today).isSome
        let hasYesterdayRecord = recordRepository.load(date: .yesterday).isSome
        let dayTitle = switch (hasTodayRecord, hasYesterdayRecord) {
        case (false, false): "하루"
        case (true, _):      "어제"
        default:             "오늘"
        }
        
        let dayType: Day = hasTodayRecord ? .yesterday : .today
        let isDayToggleEnabled = !(hasTodayRecord || hasYesterdayRecord)
        
        return RecordEntryPointStore.Context(
            dayTitle: dayTitle,
            dayType: dayType,
            isDayToggleEnabled: isDayToggleEnabled
        )
    }
}

extension DependencyValues {
    private enum GetRecordEntryContextUseCaseKey: DependencyKey {
        static let liveValue: GetRecordEntryContextUseCase = {
            @Dependency(\.recordRepository) var recordRepository
            return DefaultGetRecordEntryContextUseCase(
                recordRepository: recordRepository
            )
        }()
    }
    
    var getRecordEntryContextUseCase: GetRecordEntryContextUseCase {
        get { self[GetRecordEntryContextUseCaseKey.self] }
        set { self[GetRecordEntryContextUseCaseKey.self] = newValue }
    }
}
