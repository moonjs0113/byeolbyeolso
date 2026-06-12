//
//  FileRepository.swift
//  Domain
//
//  Created by 문종식 on 6/8/26.
//

import Foundation

public protocol FileRepository {
    func saveRewardData(from item: Reward) async throws
    func loadRewardData(from item: Reward, resourceType: Reward.ResourceType) throws -> Data
}
