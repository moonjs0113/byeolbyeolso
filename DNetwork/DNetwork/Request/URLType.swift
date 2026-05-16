//
//  DURL.swift
//  DNetwork
//
//  Created by 문종식 on 3/9/25.
//

import Foundation

public typealias DURL = URLType

public enum URLType {
    /// 개인정보처리 약관 Notion URL
    case privacyPolicy
    
    /// 앱 사용 피드백 Google Form URL
    case feedback
    
    /// API URL
    case api
    
    /// App Store Version Check URL
    case appInfo
    
    /// App Store URL
    case appStore
    
    /// 기능 제안 Google Form URL
    case proposeFunction
    
    /// 공지사항 Notion URL
    case notice
    
    /// 리워드 이벤트 피드백 URL
    case rewardFeedback

    private enum ConfigKey: String {
        case privacyPolicy = "PRIVACY_POLICY_URL"
        case feedback = "FEEDBACK_URL"
        case api = "API_BASE_URL"
        case appInfo = "APP_INFO_URL"
        case appStore = "APP_STORE_URL"
        case proposeFunction = "PROPOSE_FUNCTION_URL"
        case notice = "NOTICE_URL"
        case rewardFeedback = "REWARD_FEEDBACK_URL"
    }
    
    public var urlString: String {
        switch self {
        case .privacyPolicy:
            return configValue(for: .privacyPolicy)
        case .feedback:
            return configValue(for: .feedback)
        case .api:
            return configValue(for: .api)
        case .appInfo:
            return configValue(for: .appInfo)
        case .appStore:
            return configValue(for: .appStore)
        case .proposeFunction:
            return configValue(for: .proposeFunction)
        case .notice:
            return configValue(for: .notice)
        case .rewardFeedback:
            return configValue(for: .rewardFeedback)
        }
    }

    private func configValue(for key: ConfigKey) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            assertionFailure("Missing \(key.rawValue) in Info.plist.")
            return ""
        }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            assertionFailure("Empty \(key.rawValue) in Info.plist.")
        }
        return trimmed
    }
}
