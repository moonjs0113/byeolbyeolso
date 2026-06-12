//
//  DependencyValues+Repository.swift
//  Donmani
//
//  Created by 문종식 on 6/10/26.
//

import ComposableArchitecture
import Domain
import Repositories

extension DependencyValues {
    private enum AppVersionRepositoryKey: DependencyKey {
        static let liveValue: AppVersionRepository = RepositoryFactory.makeAppVersionRepository()
    }

    var appVersionRepository: AppVersionRepository {
        get { self[AppVersionRepositoryKey.self] }
        set { self[AppVersionRepositoryKey.self] = newValue }
    }

    private enum FeedbackRepositoryKey: DependencyKey {
        static let liveValue: FeedbackRepository = {
            @Dependency(\.keychainDataSource) var keychainDataSource
            return RepositoryFactory.makeFeedbackRepository(
                keychainDataSource: keychainDataSource
            )
        }()
    }

    var feedbackRepository: FeedbackRepository {
        get { self[FeedbackRepositoryKey.self] }
        set { self[FeedbackRepositoryKey.self] = newValue }
    }

    private enum FileRepositoryKey: DependencyKey {
        static let liveValue: FileRepository = {
            @Dependency(\.fileDataSource) var fileDataSource
            return RepositoryFactory.makeFileRepository(
                fileDataSource: fileDataSource
            )
        }()
    }

    var fileRepository: FileRepository {
        get { self[FileRepositoryKey.self] }
        set { self[FileRepositoryKey.self] = newValue }
    }

    private enum FortuneRepositoryKey: DependencyKey {
        static let liveValue: FortuneRepository = {
            @Dependency(\.keychainDataSource) var keychainDataSource
            return RepositoryFactory.makeFortuneRepository(
                keychainDataSource: keychainDataSource
            )
        }()
    }

    var fortuneRepository: FortuneRepository {
        get { self[FortuneRepositoryKey.self] }
        set { self[FortuneRepositoryKey.self] = newValue }
    }

    private enum RecordRepositoryKey: DependencyKey {
        static let liveValue: RecordRepository = {
            @Dependency(\.keychainDataSource) var keychainDataSource
            @Dependency(\.recordDataSource) var recordDataSource
            return RepositoryFactory.makeRecordRepository(
                keychainDataSource: keychainDataSource,
                recordDataSource: recordDataSource
            )
        }()
    }

    var recordRepository: RecordRepository {
        get { self[RecordRepositoryKey.self] }
        set { self[RecordRepositoryKey.self] = newValue }
    }

    private enum RewardRepositoryKey: DependencyKey {
        static let liveValue: RewardRepository = {
            @Dependency(\.keychainDataSource) var keychainDataSource
            @Dependency(\.rewardDataSource) var rewardDataSource
            return RepositoryFactory.makeRewardRepository(
                keychainDataSource: keychainDataSource,
                rewardDataSource: rewardDataSource
            )
        }()
    }

    var rewardRepository: RewardRepository {
        get { self[RewardRepositoryKey.self] }
        set { self[RewardRepositoryKey.self] = newValue }
    }

    private enum UserRepositoryKey: DependencyKey {
        static let liveValue: UserRepository = {
            @Dependency(\.keychainDataSource) var keychainDataSource
            return RepositoryFactory.makeUserRepository(
                keychainDataSource: keychainDataSource
            )
        }()
    }

    var userRepository: UserRepository {
        get { self[UserRepositoryKey.self] }
        set { self[UserRepositoryKey.self] = newValue }
    }
}
