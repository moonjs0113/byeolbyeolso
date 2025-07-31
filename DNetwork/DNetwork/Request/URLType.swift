//
//  DURL.swift
//  DNetwork
//
//  Created by 문종식 on 3/9/25.
//

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
