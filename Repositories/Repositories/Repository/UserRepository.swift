//
//  UserRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import Networking
import Domain
import Persistence

struct DefaultUserRepository: UserRepository {
    private let api = UserAPI()
    private var keychainDataSource: KeychainDataSource
    
    init(keychainDataSource: KeychainDataSource) {
        self.keychainDataSource = keychainDataSource
    }
    
    /// 사용자 이름
    private var userName: String {
        keychainDataSource.getUserName()
    }
    
    /// 사용자 ID
    private var userKey: String {
        keychainDataSource.getUserKey()
    }
    
    /// 사용자 등록
    func registerUser() async throws -> User {
        let response = try await api.postRegisterUser(userKey: userKey)
        let user = response.toDomain()
        keychainDataSource.setUserName(name: user.userName)
        return user
    }
    
    func getUserName() -> String {
        userName
    }
    
    /// 사용자 정보 업데이트
    func updateUserName(newUserName: String) async throws -> User {
        let response = try await api.postUpdateUser(userKey: userKey, newUserName: newUserName)
        let user = response.toDomain()
        keychainDataSource.setUserName(name: user.userName)
        return user
    }
    
    /// FCM 토큰 업데이트
    func postUpdateToken(token: String) async throws -> String {
        try await api.postUpdateToken(userKey: userKey, token: token)
    }
    
    /// 마지막 로그인 업데이트
    func putLastLogin() async throws {
        try await api.putLastLogin(userKey: userKey)
    }
    
    /// 공지사항 확인 상태 업데이트
    func putNoticeStatus() async throws {
        try await api.putNoticeStatus(userKey: userKey)
    }
    
    /// 공지사항 확인 상태 조회
    func getNoticeStatus() async throws -> Bool {
        let response = try await api.getNoticeStatus(userKey: userKey)
        let isRead = response.read
        return isRead
    }
    
    /// 새 리워드 아이템 확인 상태 업데이트
    func putRewardStatus() async throws {
        try await api.putRewardStatus(userKey: userKey)
    }
    
    /// 새 리워드 아이템 확인 상태 조회
    func getRewardStatus() async throws -> Bool {
        let response = try await api.getRewardStatus(userKey: userKey)
        let hasNewBadge = response.checked
        return hasNewBadge
    }
}
