import Domain
import Persistence

public enum RepositoryFactory {
    public static func makeAppVersionRepository() -> AppVersionRepository {
        DefaultAppVersionRepository()
    }

    public static func makeFeedbackRepository(
        keychainDataSource: KeychainDataSource
    ) -> FeedbackRepository {
        DefaultFeedbackRepository(
            keychainDataSource: keychainDataSource
        )
    }

    public static func makeFileRepository(
        fileDataSource: FileDataSource
    ) -> FileRepository {
        DefaultFileRepository(
            fileDataSource: fileDataSource
        )
    }

    public static func makeFortuneRepository(
        keychainDataSource: KeychainDataSource
    ) -> FortuneRepository {
        DefaultFortuneRepository(
            keychainDataSource: keychainDataSource
        )
    }

    public static func makeRecordRepository(
        keychainDataSource: KeychainDataSource,
        recordDataSource: RecordDataSource
    ) -> RecordRepository {
        DefaultRecordRepository(
            keychainDataSource: keychainDataSource,
            recordDataSource: recordDataSource
        )
    }

    public static func makeRewardRepository(
        keychainDataSource: KeychainDataSource,
        rewardDataSource: RewardDataSource
    ) -> RewardRepository {
        DefaultRewardRepository(
            keychainDataSource: keychainDataSource,
            rewardDataSource: rewardDataSource
        )
    }

    public static func makeUserRepository(
        keychainDataSource: KeychainDataSource
    ) -> UserRepository {
        DefaultUserRepository(
            keychainDataSource: keychainDataSource
        )
    }
}
