//
//  FortuneResponse.swift
//  DNetwork
//
//  Created by 문종식 on 2/9/26.
//

public struct FortuneResponse: Decodable {
    public let targetDate: String
    public let title: String
    public let subtitle: String
    public let content: String
    public let item: String
}
