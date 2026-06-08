//
//  User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

public struct User: Codable {
    public let userKey: String
    public var userName: String
    public var new: Bool
    
    public init(userKey: String, userName: String, new: Bool) {
        self.userKey = userKey
        self.userName = userName
        self.new = new
    }
}
