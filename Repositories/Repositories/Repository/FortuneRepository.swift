//
//  FortuneRepository.swift
//  Donmani
//
//  Created by 문종식 on 2/15/26.
//

import Networking
import Domain
import Persistence

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
    
    func putFortuneRead(readSource: FortuneReadSource) async throws {
        try await dataSource.putFortuneRead(
            userKey: userKey,
            readSource: readSource.rawValue
        )
    }
}
