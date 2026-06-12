//
//  AppVersionRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import Networking
import Domain

struct DefaultAppVersionRepository: AppVersionRepository {
    private let api = AppVersionAPI()
    
    /// 앱 버전 정보 요청
    func getAppVersion() async throws -> Version {
        let response = try await api.getAppVersion()
        return response.toDomain()
    }
}
