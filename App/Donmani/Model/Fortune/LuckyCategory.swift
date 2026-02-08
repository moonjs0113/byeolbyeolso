//
//  LuckyCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/8/26.
//

enum LuckyCategory {
    case item
    case color
    case food
    case place
    case direction
    case person
    case price
    case time
    case action
    
    var title: String {
        switch self {
        case .item:
            "아이템"
        case .color:
            "색"
        case .food:
            "음식"
        case .place:
            "장소"
        case .direction:
            "방향"
        case .person:
            "사람"
        case .price:
            "금액"
        case .time:
            "시간"
        case .action:
            "행동"
        }
    }
}
