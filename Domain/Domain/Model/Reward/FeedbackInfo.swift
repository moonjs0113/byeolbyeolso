//
//  FeedbackInfo.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

public struct FeedbackInfo {
    public let isNotOpened: Bool
    public let isFirstOpened: Bool
    public let totalCount: Int
    
    public init(isNotOpened: Bool, isFirstOpened: Bool, totalCount: Int) {
        self.isNotOpened = isNotOpened
        self.isFirstOpened = isFirstOpened
        self.totalCount = totalCount
    }
}
