//
//  RecordRepository.swift
//  Domain
//
//  Created by 문종식 on 6/8/26.
//

public protocol RecordRepository {
    func save(_ record: Record)
    func load(date: Day) -> Record?
    func saveRecords(_ records: [Record])
    func loadRecords(year: Int, month: Int) -> [Record]?
    func postRecord(record: Record) async throws
    func getMonthlyRecordList(year: Int, month: Int) async throws -> MonthlyRecordState
    func getMonthlyRecordCalendar(year: Int, month: Int) async throws -> MonthlyRecordState
    func getMonthlyRecordStatistics(year: Int, month: Int) async throws -> RecordStatistics
    func getMonthlyCategoryStatistics(year: Int, month: Int) async throws -> CategoryStatistics
    func getYearlyRecordSummary(year: Int) async throws -> RecordCountSummary
}
