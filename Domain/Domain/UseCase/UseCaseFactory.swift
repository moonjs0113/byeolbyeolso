//
//  UseCaseFactory.swift
//  Domain
//
//  Created by 문종식 on 6/13/26.
//

import Foundation

public enum UseCaseFactory {
    public static func makeGetRecordEntryDayTitleUseCase(
        recordRepository: RecordRepository
    ) -> GetRecordEntryDayTitleUseCase {
        DefaultGetRecordEntryDayTitleUseCase(recordRepository: recordRepository)
    }

    public static func makeCanWriteRecordUseCase(
        recordRepository: RecordRepository
    ) -> CanWriteRecordUseCase {
        DefaultCanWriteRecordUseCase(recordRepository: recordRepository)
    }
}
