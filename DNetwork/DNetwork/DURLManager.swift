//
//  DURLManager.swift
//  DNetwork
//
//  Created by 문종식 on 3/9/25.
//

public enum DURLManager {
    case privacyPolicy
    case feedback
    case api
    case appInfo
    case appStore
    
    public var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://littlemoom.notion.site/bbs-term?pvs=4"
        case .feedback:
            return "__REDACTED_FEEDBACK_URL__"
        case .api:
            return "http://211.188.60.38:8080"
        case .appInfo:
            return "__REDACTED_APP_INFO_URL__"
        case .appStore:
            return "__REDACTED_APP_STORE_URL__"
        }
    }
}
