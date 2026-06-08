//
//  RecordContent.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

public struct RecordContent {
    public var flag: RecordContentType
    public var category: RecordCategory
    public var memo: String
    
    public init(
        flag: RecordContentType,
        category: RecordCategory,
        memo: String
    ) {
        self.flag = flag
        self.category = category
        self.memo = memo
    }
}
