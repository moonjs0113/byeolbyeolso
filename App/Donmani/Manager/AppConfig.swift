//
//  AppConfig.swift
//  Donmani
//
//  Created by 문종식 on 5/15/26.
//

import Foundation
import Domain

enum AppConfig {
    enum Key: String {
        case admobBannerAdUnitID = "ADMOB_BANNER_AD_UNIT_ID"
        case adminID = "ADMIN_ID"
    }

    static func string(_ key: Key) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            return nil
        }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
