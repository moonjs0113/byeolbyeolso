//
//  DefaultSettingsDataSource.swift
//  Persistence
//
//  Created by 문종식 on 6/13/26.
//

import Foundation

public final class DefaultSettingsDataSource: SettingsDataSource {
    // rawValue를 직접 지정한 case는 민감 정보로 변경이 어려운 case입니다.
    private enum Key: String {
        case shouldShowOnboarding = "IS_SHOWN_ONBOARDING"
        case APNsToken = "APNS_TOKEN"
        case firebaseToken = "FIREBASE_TOKEN"
        case shouldShowAppStoreReviewRequest
        case lastRecordDay
        case secondToLastRecordDay
        case shouldShowEmptyRecordToolTip
        case shouldShowBottleCalendarTopBanner
        case shouldShowRequestNotificationPermission
        case shouldShowBottleCalendarToolTip
        case streakSubmitCount = "STREAK_SUBMIT_COUNT"
        case lastWriteRecordDate = "LAST_WRITE_RECORD_DATE"
        case shouldShowRewardEventBottomSheet
        case shouldShowDecorationGuideBottomSheet
        case shouldShowDecorationSaveAlert
        case shouldShowFullRewardBottomSheet
        case lastNewBottleGuideDay
        case shouldShowRewardToolTip
        case lastFortuneDay
        case shouldShowInitialFortuneModal
        case shouldShowFortuneByNotification
        case shouldPushRecordAfterFortuneConfirm
        case appVersion
    }

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public var shouldShowOnboarding: Bool {
        get { bool(for: .shouldShowOnboarding, defaultValue: false) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowOnboarding.rawValue) }
    }

    public var APNsToken: Data {
        get { data(for: .APNsToken, defaultValue: Data()) }
        set { userDefaults.set(newValue, forKey: Key.APNsToken.rawValue) }
    }

    public var firebaseToken: String {
        get { string(for: .firebaseToken, defaultValue: "") }
        set { userDefaults.set(newValue, forKey: Key.firebaseToken.rawValue) }
    }

    public var shouldShowAppStoreReviewRequest: Bool {
        get { bool(for: .shouldShowAppStoreReviewRequest, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowAppStoreReviewRequest.rawValue) }
    }

    public var lastRecordDay: String {
        get { string(for: .lastRecordDay, defaultValue: "0000-00-00") }
        set { userDefaults.set(newValue, forKey: Key.lastRecordDay.rawValue) }
    }

    public var secondToLastRecordDay: String {
        get { string(for: .secondToLastRecordDay, defaultValue: "0000-00-00") }
        set { userDefaults.set(newValue, forKey: Key.secondToLastRecordDay.rawValue) }
    }

    public var shouldShowEmptyRecordToolTip: Bool {
        get { bool(for: .shouldShowEmptyRecordToolTip, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowEmptyRecordToolTip.rawValue) }
    }

    public var shouldShowBottleCalendarTopBanner: Bool {
        get { bool(for: .shouldShowBottleCalendarTopBanner, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowBottleCalendarTopBanner.rawValue) }
    }

    public var shouldShowRequestNotificationPermission: Bool {
        get { bool(for: .shouldShowRequestNotificationPermission, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowRequestNotificationPermission.rawValue) }
    }

    public var shouldShowBottleCalendarToolTip: Bool {
        get { bool(for: .shouldShowBottleCalendarToolTip, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowBottleCalendarToolTip.rawValue) }
    }

    public var streakSubmitCount: Int {
        get { int(for: .streakSubmitCount, defaultValue: 0) }
        set { userDefaults.set(newValue, forKey: Key.streakSubmitCount.rawValue) }
    }

    public var lastWriteRecordDate: String {
        get { string(for: .lastWriteRecordDate, defaultValue: "") }
        set { userDefaults.set(newValue, forKey: Key.lastWriteRecordDate.rawValue) }
    }

    public var shouldShowRewardEventBottomSheet: Bool {
        get { bool(for: .shouldShowRewardEventBottomSheet, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowRewardEventBottomSheet.rawValue) }
    }

    public var shouldShowDecorationGuideBottomSheet: Bool {
        get { bool(for: .shouldShowDecorationGuideBottomSheet, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowDecorationGuideBottomSheet.rawValue) }
    }

    public var shouldShowDecorationSaveAlert: Bool {
        get { bool(for: .shouldShowDecorationSaveAlert, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowDecorationSaveAlert.rawValue) }
    }

    public var shouldShowFullRewardBottomSheet: Bool {
        get { bool(for: .shouldShowFullRewardBottomSheet, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowFullRewardBottomSheet.rawValue) }
    }

    public var lastNewBottleGuideDay: String {
        get { string(for: .lastNewBottleGuideDay, defaultValue: "0000-00-00") }
        set { userDefaults.set(newValue, forKey: Key.lastNewBottleGuideDay.rawValue) }
    }

    public var shouldShowRewardToolTip: Bool {
        get { bool(for: .shouldShowRewardToolTip, defaultValue: false) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowRewardToolTip.rawValue) }
    }

    public var lastFortuneDay: String {
        get { string(for: .lastFortuneDay, defaultValue: "00000000") }
        set { userDefaults.set(newValue, forKey: Key.lastFortuneDay.rawValue) }
    }

    public var shouldShowInitialFortuneModal: Bool {
        get { bool(for: .shouldShowInitialFortuneModal, defaultValue: true) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowInitialFortuneModal.rawValue) }
    }

    public var shouldShowFortuneByNotification: Bool {
        get { bool(for: .shouldShowFortuneByNotification, defaultValue: false) }
        set { userDefaults.set(newValue, forKey: Key.shouldShowFortuneByNotification.rawValue) }
    }

    public var shouldPushRecordAfterFortuneConfirm: Bool {
        get { bool(for: .shouldPushRecordAfterFortuneConfirm, defaultValue: false) }
        set { userDefaults.set(newValue, forKey: Key.shouldPushRecordAfterFortuneConfirm.rawValue) }
    }

    public var appVersion: String {
        get { string(for: .appVersion, defaultValue: "0.0.0") }
        set { userDefaults.set(newValue, forKey: Key.appVersion.rawValue) }
    }

    private func bool(for key: Key, defaultValue: Bool) -> Bool {
        userDefaults.object(forKey: key.rawValue) as? Bool ?? defaultValue
    }

    private func data(for key: Key, defaultValue: Data) -> Data {
        userDefaults.object(forKey: key.rawValue) as? Data ?? defaultValue
    }

    private func int(for key: Key, defaultValue: Int) -> Int {
        userDefaults.object(forKey: key.rawValue) as? Int ?? defaultValue
    }

    private func string(for key: Key, defaultValue: String) -> String {
        userDefaults.object(forKey: key.rawValue) as? String ?? defaultValue
    }
}
