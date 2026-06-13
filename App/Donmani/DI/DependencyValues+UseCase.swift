//
//  DependencyValues+UseCase.swift
//  Donmani
//
//  Created by 문종식 on 6/13/26.
//

import ComposableArchitecture
import Domain

extension DependencyValues {
    private enum GetRecordEntryDayTitleUseCaseKey: DependencyKey {
        static let liveValue: GetRecordEntryDayTitleUseCase = {
            @Dependency(\.recordRepository) var recordRepository
            return UseCaseFactory.makeGetRecordEntryDayTitleUseCase(
                recordRepository: recordRepository
            )
        }()
    }

    var getRecordEntryDayTitleUseCase: GetRecordEntryDayTitleUseCase {
        get { self[GetRecordEntryDayTitleUseCaseKey.self] }
        set { self[GetRecordEntryDayTitleUseCaseKey.self] = newValue }
    }

    private enum CanWriteRecordUseCaseKey: DependencyKey {
        static let liveValue: CanWriteRecordUseCase = {
            @Dependency(\.recordRepository) var recordRepository
            return UseCaseFactory.makeCanWriteRecordUseCase(
                recordRepository: recordRepository
            )
        }()
    }

    var canWriteRecordUseCase: CanWriteRecordUseCase {
        get { self[CanWriteRecordUseCaseKey.self] }
        set { self[CanWriteRecordUseCaseKey.self] = newValue }
    }
}
