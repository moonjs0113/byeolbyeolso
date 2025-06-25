//
//  DURL.swift
//  DNetwork
//
//  Created by 문종식 on 3/9/25.
//

public enum DURL {
    case privacyPolicy
    case feedback
    case api
    case appInfo
    case appStore
    case proposeFunction
    case notice
    case rewardFeedback
    
    public var urlString: String {
        switch self {
        case .privacyPolicy:
            return "__REDACTED_PRIVACY_POLICY_URL__"
        case .feedback:
            return "__REDACTED_FEEDBACK_URL__"
        case .api:
            return "__REDACTED_API_BASE_URL__" // "https://www.donmani.kr"
        case .appInfo:
            return "__REDACTED_APP_INFO_URL__"
        case .appStore:
            return "__REDACTED_APP_STORE_URL__"
        case .proposeFunction:
            return "__REDACTED_PROPOSE_FUNCTION_URL__"
        case .notice:
            return "__REDACTED_NOTICE_URL__"
        case .rewardFeedback:
            return "__REDACTED_REWARD_FEEDBACK_URL__"
        }
    }
}
