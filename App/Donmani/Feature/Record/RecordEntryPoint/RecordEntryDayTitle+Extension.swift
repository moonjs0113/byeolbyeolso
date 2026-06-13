//
//  RecordEntryDayTitle+Extension.swift
//  Donmani
//
//  Created by 문종식 on 6/13/26.
//

import Domain

extension RecordEntryDayTitle {
    var displayTitle: String {
        switch self {
        case .today: "오늘"
        case .yesterday: "어제"
        case .oneDay: "하루"
        }
    }
}
