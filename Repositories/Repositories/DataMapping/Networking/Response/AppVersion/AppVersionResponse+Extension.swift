//
//  AppVersionResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import Networking
import Domain

extension AppVersionResponse {
    func toDomain() -> Version {
        Version(
            latestVersion: self.latestVersion,
            isUpdateRequired: self.forcedUpdateYn == "Y"
        )
    }
}
