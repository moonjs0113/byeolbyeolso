//
//  RecordDataSource.swift
//  Persistence
//
//  Created by 문종식 on 2/16/25.
//

import Domain

public protocol RecordDataSource {
    func save(_ record: Record)
    func load(year: Int, month: Int, day: Int) -> Record?
    func loadRecords(year: Int, month: Int) -> [Record]?
}
