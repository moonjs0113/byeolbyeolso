//
//  DayTests.swift
//  DonmaniTests
//
//  Created by Codex on 5/15/26.
//

import Testing
@testable import Donmani

struct DayTests {
    @Test
    func parse_yyyyMMdd_success() async throws {
        let day = Day(yyyymmdd: "2026-05-15")
        #expect(day?.year == 2026)
        #expect(day?.month == 5)
        #expect(day?.day == 15)
    }

    @Test
    func parse_yyyyMMdd_invalidDate_returnsNil() async throws {
        #expect(Day(yyyymmdd: "2026-02-30") == nil)
    }

    @Test
    func parse_yyMMdd_success() async throws {
        let day = Day(yymmdd: "26-05-15")
        #expect(day?.year == 2026)
        #expect(day?.month == 5)
        #expect(day?.day == 15)
    }

    @Test
    func parse_yyMMdd_invalidFormat_returnsNil() async throws {
        #expect(Day(yymmdd: "2026-05-15") == nil)
    }
}
