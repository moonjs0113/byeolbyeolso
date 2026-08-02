//
//  DayTests.swift
//  DomainTests
//
//  Created by 문종식 on 5/15/26.
//

import Testing
@testable import Domain

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
        #expect(Day(yymmdd: "26-13-01") == nil)
        #expect(Day(yymmdd: "26-00-01") == nil)
    }

    @Test
    func parse_yyyyMMdd_invalidFormat_returnsNil() async throws {
        #expect(Day(yyyymmdd: "2026-5-15") == nil)
        #expect(Day(yyyymmdd: "26-05-15") == nil)
        #expect(Day(yyyymmdd: "20260515") == nil)
    }

    @Test
    func parse_yyyyMMdd_leapYear_validation() async throws {
        #expect(Day(yyyymmdd: "2024-02-29") != nil)
        #expect(Day(yyyymmdd: "2025-02-29") == nil)
        #expect(Day(yyyymmdd: "2100-02-29") == nil)
        #expect(Day(yyyymmdd: "2000-02-29") != nil)
    }

    @Test
    func comparable_comparesYearFirst() async throws {
        let lhs = Day(year: 2026, month: 1, day: 1)
        let rhs = Day(year: 2025, month: 12, day: 31)
        #expect(lhs > rhs)
        #expect(!(lhs < rhs))
    }

    @Test
    func comparable_comparesMonthAndDayWithinSameYear() async throws {
        let january = Day(year: 2026, month: 1, day: 31)
        let february = Day(year: 2026, month: 2, day: 1)
        #expect(january < february)
        #expect(february > january)
    }

    @Test
    func comparable_sortingOrder_isChronological() async throws {
        let values = [
            Day(year: 2026, month: 12, day: 1),
            Day(year: 2025, month: 3, day: 1),
            Day(year: 2026, month: 1, day: 2),
            Day(year: 2026, month: 1, day: 1)
        ]
        let sorted = values.sorted()
        #expect(sorted.map(\.yyyyMMddCompact) == [
            "20250301",
            "20260101",
            "20260102",
            "20261201"
        ])
    }

    @Test
    func equatable_sameDate_isEqual() async throws {
        let first = Day(year: 2026, month: 5, day: 15)
        let second = Day(year: 2026, month: 5, day: 15)
        #expect(first == second)
    }

    @Test
    func rawInit_invalidDate_fallsBackToToday() async throws {
        let day = Day(year: 2026, month: 13, day: 40)
        #expect(day == .today)
    }

    @Test
    func lastDaysOfMonths_nonLeapAndLeapYear() async throws {
        let y2025 = Day.lastDaysOfMonths(year: 2025)
        let y2024 = Day.lastDaysOfMonths(year: 2024)

        #expect(y2025[2] == 28)
        #expect(y2024[2] == 29)
        #expect(y2025[4] == 30)
        #expect(y2025[12] == 31)
    }

    @Test
    func format_compactAndDashed() async throws {
        let day = Day(year: 2026, month: 5, day: 9)
        #expect(day.yyyyMMdd == "2026-05-09")
        #expect(day.yyyyMMddCompact == "20260509")
    }

    @Test
    func toDate_roundTripsBackToDay() async throws {
        let day = Day(year: 2026, month: 7, day: 17)
        let date = try #require(day.toDate)
        #expect(Day(date: date) == day)
    }

    @Test
    func addingDays_movesBackwardIncludingMonthBoundary() async throws {
        let startDay = Day(year: 2026, month: 7, day: 17)
        let endDay = try #require(startDay.adding(day: -6))
        #expect(endDay == Day(year: 2026, month: 7, day: 11))
    }

    @Test
    func addingDays_movesAcrossYearBoundary() async throws {
        let startDay = Day(year: 2026, month: 1, day: 1)
        let previousDay = try #require(startDay.adding(day: -1))
        #expect(previousDay == Day(year: 2025, month: 12, day: 31))
    }

    @Test
    func adding_withAllNil_returnsSameDay() async throws {
        let day = Day(year: 2026, month: 7, day: 26)
        let sameDay = try #require(day.adding())
        #expect(sameDay == day)
    }

    @Test
    func weekday_returnsKoreanWeekday() async throws {
        let day = Day(year: 2026, month: 5, day: 15)
        #expect(day.weekday == "금")
    }
}
