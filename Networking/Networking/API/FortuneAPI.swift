//
//  FortuneAPI.swift
//  Networking
//
//  Created by 문종식 on 2/9/26.
//

public struct FortuneAPI {
    private let request = NetworkRequest()
    
    public init() { }
    
    /// 오늘의 운세 조회
    public func getTodayFortune(userKey: String) async throws -> FortuneResponse {
        let result: ResponseWrapper<FortuneResponse> = try await request.get(
            path: .fortune,
            additionalPaths: [userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 오늘의 운세 읽음 처리
    public func putFortuneRead(userKey: String, readSource: String) async throws {
        let _: EmptyResponse = try await request.put(
            path: .fortune,
            additionalPaths: ["read"],
            bodyData: FortuneReadRequest(
                userKey: userKey,
                readSource: readSource
            )
        )
    }
}
