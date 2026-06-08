//
//  AppVersionRepository.swift
//  Domain
//
//  Created by 문종식 on 6/8/26.
//

public protocol AppVersionRepository {
    func getAppVersion() async throws -> Version
}
