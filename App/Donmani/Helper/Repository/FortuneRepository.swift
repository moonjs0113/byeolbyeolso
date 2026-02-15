//
//  FortuneRepository.swift
//  Donmani
//
//  Created by 문종식 on 2/15/26.
//

import DNetwork
import ComposableArchitecture

protocol FortuneRepository {
    func getTodayFortune() async throws -> Fortune
    func postFortuneRead(readSource: FortuneReadSource) async throws
}

struct DefaultFortuneRepository: FortuneRepository {
    private let dataSource = FortuneAPI()
    private var keychainDataSource: KeychainDataSource

    init(keychainDataSource: KeychainDataSource) {
        self.keychainDataSource = keychainDataSource
    }

    private var userKey: String {
        keychainDataSource.getUserKey()
    }

    func getTodayFortune() async throws -> Fortune {
        let response = try await dataSource.getTodayFortune(userKey: userKey)
        return response.toDomain()
    }
    
    func postFortuneRead(readSource: FortuneReadSource) async throws {
        try await dataSource.postFortuneRead(
            userKey: userKey,
            readSource: readSource.rawValue
        )
    }
}

extension DependencyValues {
    private enum FortuneRepositoryKey: DependencyKey {
        static let liveValue: FortuneRepository = {
            @Dependency(\.keychainDataSource) var keychainDataSource
            return DefaultFortuneRepository(
                keychainDataSource: keychainDataSource
            )
        }()
    }

    var fortuneRepository: FortuneRepository {
        get { self[FortuneRepositoryKey.self] }
        set { self[FortuneRepositoryKey.self] = newValue }
    }
}
