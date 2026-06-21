//
//  SettingsDataSource.swift
//  Persistence
//
//  Created by 문종식 on 6/13/26.
//

import Foundation

public protocol SettingsDataSource: AnyObject {
    var shouldShowOnboarding: Bool { get set }
    var APNsToken: Data { get set }
    var firebaseToken: String { get set }
    var shouldShowAppStoreReviewRequest: Bool { get set }
    var lastRecordDay: String { get set }
    var secondToLastRecordDay: String { get set }
    var shouldShowEmptyRecordToolTip: Bool { get set }
    var shouldShowBottleCalendarTopBanner: Bool { get set }
    var shouldShowRequestNotificationPermission: Bool { get set }
    var shouldShowBottleCalendarToolTip: Bool { get set }
    var streakSubmitCount: Int { get set }
    var lastWriteRecordDate: String { get set }
    var shouldShowRewardEventBottomSheet: Bool { get set }
    var shouldShowDecorationGuideBottomSheet: Bool { get set }
    var shouldShowDecorationSaveAlert: Bool { get set }
    var shouldShowFullRewardBottomSheet: Bool { get set }
    var lastNewBottleGuideDay: String { get set }
    var shouldShowRewardToolTip: Bool { get set }
    var lastFortuneDay: String { get set }
    var shouldShowFortuneByNotification: Bool { get set }
    var shouldPushRecordAfterFortuneConfirm: Bool { get set }
    var appVersion: String { get set }
}
