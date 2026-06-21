public enum PersistenceFactory {
    public static func makeSettings() -> any SettingsDataSource {
        DefaultSettingsDataSource()
    }

    public static func makeFileDataSource() -> FileDataSource {
        DefaultFileDataSource()
    }

    public static func makeKeychainDataSource() -> KeychainDataSource {
        DefaultKeychainDataSource()
    }

    public static func makeRecordDataSource() -> RecordDataSource {
        DefaultRecordDataSource()
    }

    public static func makeRewardDataSource() -> RewardDataSource {
        DefaultRewardDataSource()
    }
}
