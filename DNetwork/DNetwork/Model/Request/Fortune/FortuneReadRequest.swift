//
//  FortuneReadRequest.swift
//  DNetwork
//
//  Created by 문종식 on 2/9/26.
//

public struct FortuneReadRequest: Encodable {
    private let userKey: String
    private let readSource: FortuneReadSourceRequest
    
    init(userKey: String, readSource: FortuneReadSourceRequest) {
        self.userKey = userKey
        self.readSource = readSource
    }
}
