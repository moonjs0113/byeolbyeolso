//
//  DependencyValues+DataSource.swift
//  Donmani
//
//  Created by 문종식 on 6/10/26.
//

import ComposableArchitecture
import Persistence

extension DependencyValues {
    private enum KeychainDataSourceKey: DependencyKey {
        static let liveValue: KeychainDataSource = PersistenceFactory.makeKeychainDataSource()
    }

    var keychainDataSource: KeychainDataSource {
        get { self[KeychainDataSourceKey.self] }
        set { self[KeychainDataSourceKey.self] = newValue }
    }

    private enum RecordDataSourceKey: DependencyKey {
        static let liveValue: RecordDataSource = PersistenceFactory.makeRecordDataSource()
    }

    var recordDataSource: RecordDataSource {
        get { self[RecordDataSourceKey.self] }
        set { self[RecordDataSourceKey.self] = newValue }
    }

    private enum RewardDataSourceKey: DependencyKey {
        static let liveValue: RewardDataSource = PersistenceFactory.makeRewardDataSource()
    }

    var rewardDataSource: RewardDataSource {
        get { self[RewardDataSourceKey.self] }
        set { self[RewardDataSourceKey.self] = newValue }
    }

    private enum FileDataSourceKey: DependencyKey {
        static let liveValue: FileDataSource = PersistenceFactory.makeFileDataSource()
    }

    var fileDataSource: FileDataSource {
        get { self[FileDataSourceKey.self] }
        set { self[FileDataSourceKey.self] = newValue }
    }
}
