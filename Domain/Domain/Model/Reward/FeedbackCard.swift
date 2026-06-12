//
//  FeedbackCard.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

public struct FeedbackCard {
    public let category: RecordCategory
    public let title: String
    public let content: String
    public let prefix: String
    
    public init(category: RecordCategory, title: String, content: String, prefix: String) {
        self.category = category
        self.title = title
        self.content = content
        self.prefix = prefix
    }

    public static var previewData: FeedbackCard {
        FeedbackCard(
            category: .happiness,
            title: "최대 12자 타이틀",
            content: "나만 아는 행복이었던 것 같아,\n그래서 더 소중해 💛",
            prefix: "오늘은"
        )
    }
}
