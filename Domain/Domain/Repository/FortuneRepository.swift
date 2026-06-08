//
//  FortuneRepository.swift
//  Domain
//
//  Created by 문종식 on 6/8/26.
//

public protocol FortuneRepository {
    func getTodayFortune() async throws -> Fortune
    func putFortuneRead(readSource: FortuneReadSource) async throws
}
