//
//  Fortune.swift
//  Donmani
//
//  Created by 문종식 on 2/8/26.
//

struct Fortune {
    let day: Day
    let content: String
    let luckyCategory: LuckyCategory
    let luckyCategoryValue: String
    
    init(day: Day = .today, content: String, luckyCategory: LuckyCategory, luckyCategoryValue: String) {
        self.day = day
        self.content = content
        self.luckyCategory = luckyCategory
        self.luckyCategoryValue = luckyCategoryValue
    }
    
    init() {
        self.day = .today
        self.content = ""
        self.luckyCategory = .item
        self.luckyCategoryValue = ""
    }
}

