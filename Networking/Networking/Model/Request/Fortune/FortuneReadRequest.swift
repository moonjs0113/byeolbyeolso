//
//  FortuneReadRequest.swift
//  Networking
//
//  Created by 문종식 on 2/9/26.
//

public struct FortuneReadRequest: Encodable {
    private let userKey: String
    private let readSource: String
    
    init(userKey: String, readSource: String) {
        self.userKey = userKey
        self.readSource = readSource
    }
}
