//
//  DayType.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

public enum DayType {
    case today
    case yesterday
    
    public var title: String {
        switch self {
        case .today:
            return "오늘"
        case .yesterday:
            return "내일"
        } 
    }
}
