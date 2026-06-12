//
//  Version.swift
//  Donmani
//
//  Created by 문종식 on 4/16/25.
//

public struct Version {
    public let latestVersion: String
    public let isUpdateRequired: Bool
    
    public init(latestVersion: String, isUpdateRequired: Bool) {
        self.latestVersion = latestVersion
        self.isUpdateRequired = isUpdateRequired
    }
}
