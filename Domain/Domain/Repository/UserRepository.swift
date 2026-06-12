//
//  UserRepository.swift
//  Domain
//
//  Created by 문종식 on 6/8/26.
//

public protocol UserRepository {
    func registerUser() async throws -> User
    func getUserName() -> String
    func updateUserName(newUserName: String) async throws -> User
    func postUpdateToken(token: String) async throws -> String
    func putLastLogin() async throws
    func putNoticeStatus() async throws
    func getNoticeStatus() async throws -> Bool
    func putRewardStatus() async throws
    func getRewardStatus() async throws -> Bool
}
