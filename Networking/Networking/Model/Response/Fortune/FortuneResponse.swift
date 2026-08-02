//
//  FortuneResponse.swift
//  Networking
//
//  Created by 문종식 on 2/9/26.
//

public struct FortuneResponse: Decodable {
    public let targetDate: String // YYYY-MM-DD
    public let title: String?
    public let subtitle: String
    public let content: String
    public let item: String
    public let imageUrl: String?
}
