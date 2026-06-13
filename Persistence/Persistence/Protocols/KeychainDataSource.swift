//
//  KeychainDataSource.swift
//  Persistence
//
//  Created by 문종식 on 2/13/25.
//

public protocol KeychainDataSource {
    func generateUUID()
    func getUserKey() -> String
    func getUserName() -> String
    func setUserName(name: String)
}
