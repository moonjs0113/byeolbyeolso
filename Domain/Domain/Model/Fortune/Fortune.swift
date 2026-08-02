//
//  Fortune.swift
//  Donmani
//
//  Created by 문종식 on 2/8/26.
//

public struct Fortune {
    public let day: Day
    public let title: String
    public let subtitle: String
    public let content: String
    public let item: String
    public let imageUrl: String
    
    public init(day: Day, title: String, subtitle: String, content: String, item: String, imageUrl: String) {
        self.day = day
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.item = item
        self.imageUrl = imageUrl
    }
    
    public static let empty = Fortune(
        day: .today,
        title: "",
        subtitle: "",
        content: "",
        item: "",
        imageUrl: ""
    )
}
