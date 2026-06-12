//
//  RecordRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/28/25.
//

import Networking
import Domain
import Persistence

struct DefaultRecordRepository: RecordRepository {
    private let api = RecordAPI()
    private var keychainDataSource: KeychainDataSource
    private var recordDataSource: RecordDataSource
    
    init(
        keychainDataSource: KeychainDataSource,
        recordDataSource: RecordDataSource
    ) {
        self.keychainDataSource = keychainDataSource
        self.recordDataSource = recordDataSource
    }
    
    // KeychainDataSource
    /// 사용자 ID
    private var userKey: String {
        keychainDataSource.getUserKey()
    }
    
    // RecordDataSource
    /// 기록을 저장합니다.
    func save(_ record: Record) {
        recordDataSource.save(record)
    }
    
    /// 기록을 불러옵니다.
    func load(date: Day) -> Record? {
        recordDataSource.load(
            year: date.year,
            month: date.month,
            day: date.day
        )
    }
    
    /// 기록 리스트를 저장합니다.
    func saveRecords(_ records: [Record]) {
        for record in records {
            save(record)
        }
    }
    
    /// 기록 리스트를 불러옵니다.
    func loadRecords(year: Int, month: Int) -> [Record]? {
        recordDataSource.loadRecords(year: year, month: month)
    }
    
    // RecordAPI
    /// 기록 작성
    func postRecord(record: Record) async throws {
        let bodyData = RecordRequest(userKey: userKey, record: record)
        try await api.postRecord(bodyData: bodyData)
    }
    
    /// 월별 기록 정보(리스트)
    func getMonthlyRecordList(year: Int, month: Int) async throws -> MonthlyRecordState {
        try await api.getMonthlyRecordList(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월별 기록 정보(캘린더)
    func getMonthlyRecordCalendar(year: Int, month: Int) async throws -> MonthlyRecordState {
        try await api.getMonthlyRecordCalendar(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월별 행복/후회 기록 개수 통계
    func getMonthlyRecordStatistics(year: Int, month: Int) async throws -> RecordStatistics {
        try await api.getMonthlyRecordStatistics(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월간 카테고리별 기록 수
    func getMonthlyCategoryStatistics(year: Int, month: Int) async throws -> CategoryStatistics {
        try await api.getMonthlyCategoryStatistics(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 연간 기록(별통이 달력)
    func getYearlyRecordSummary(year: Int) async throws -> RecordCountSummary {
        try await api.getYearlyRecordSummary(
            userKey: userKey,
            year: year
        ).toDomain()
    }
}
