//
//  FeedbackRepository.swift
//  Domain
//
//  Created by 문종식 on 6/8/26.
//

public protocol FeedbackRepository {
    func getFeedbackState() async throws -> FeedbackInfo
    func getFeedbackCard() async throws -> FeedbackCard
}
