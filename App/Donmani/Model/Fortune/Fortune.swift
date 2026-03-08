//
//  Fortune.swift
//  Donmani
//
//  Created by 문종식 on 2/8/26.
//

struct Fortune {
    let day: Day
    let title: String
    let subtitle: String
    let content: String
    let item: String
    
    init(day: Day, title: String, subtitle: String, content: String, item: String) {
        self.day = day
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.item = item
    }
    
    static let empty = Fortune(
        day: .today,
        title: "",
        subtitle: "",
        content: "",
        item: ""
    )
}

