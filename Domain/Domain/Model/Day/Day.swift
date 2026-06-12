//
//  Day.swift
//  Donmani
//
//  Created by 문종식 on 4/3/25.
//

import Foundation

public struct Day {
    public let year: Int
    public let month: Int
    public let day: Int
    
    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    /// YYYY-MM-DD 형식의 문자열로 초기화
    public init?(yyyymmdd: String) {
        let split = yyyymmdd.components(separatedBy: "-")
        guard split.count == 3,
              split[0].count == 4,
              split[1].count == 2,
              split[2].count == 2,
              let year = Int(split[0]),
              let month = Int(split[1]),
              let day = Int(split[2]),
              Day.isValid(year: year, month: month, day: day) else {
            return nil
        }
        self.init(year: year, month: month, day: day)
    }
    
    /// YY-MM-DD 형식의 문자열로 초기화
    public init?(yymmdd: String) {
        let split = yymmdd.components(separatedBy: "-")
        guard split.count == 3,
              split[0].count == 2,
              split[1].count == 2,
              split[2].count == 2,
              let shortYear = Int(split[0]),
              let month = Int(split[1]),
              let day = Int(split[2]) else {
            return nil
        }
        let year = shortYear + 2000
        guard Day.isValid(year: year, month: month, day: day) else {
            return nil
        }
        self.init(year: year, month: month, day: day)
    }
}

private extension Day {
    static func isValid(year: Int, month: Int, day: Int) -> Bool {
        guard (1...9999).contains(year),
              (1...12).contains(month),
              (1...31).contains(day) else {
            return false
        }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = DateComponents(year: year, month: month, day: day)
        guard let date = calendar.date(from: components) else {
            return false
        }
        let normalized = calendar.dateComponents([.year, .month, .day], from: date)
        return normalized.year == year
            && normalized.month == month
            && normalized.day == day
    }
}

extension Day: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }
}

extension Day: Equatable, Comparable {
    public static func < (lhs: Day, rhs: Day) -> Bool {
        lhs.compareKey < rhs.compareKey
    }
    
    public static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.compareKey == rhs.compareKey
    }
}

extension Day {
    private var compareKey: Int {
        (year * 10_000) + (month * 100) + day
    }

    /// YYYY-MM-DD
    public var yyyyMMdd: String {
        "\(year)-\(Self.twoDigitString(month))-\(Self.twoDigitString(day))"
    }

    /// YYYYMMDD
    public var yyyyMMddCompact: String {
        "\(year)\(Self.twoDigitString(month))\(Self.twoDigitString(day))"
    }
    
    public var toDate: Date? {
        let dateString = "\(year)-\(month)-\(day)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: dateString)
    }
    
    public var dateString: String {
        guard let date = self.toDate else {
            return ""
        }
        let koreanFormatter = DateFormatter()
        koreanFormatter.dateFormat = "M월 d일 EEE요일"
        koreanFormatter.locale = Locale(identifier: "ko_KR")
        return koreanFormatter.string(from: date)
    }
    
    public var fortuneDate: String {
        guard let date = self.toDate else {
            return ""
        }
        
        let fortuneDateFormatter = DateFormatter()
        fortuneDateFormatter.dateFormat = "YY년 M월 d일 운세"
        fortuneDateFormatter.locale = Locale(identifier: "ko_KR")
        return fortuneDateFormatter.string(from: date)
    }
}

// Static
extension Day {
    public static var distantPast: Day {
        Day(year: 1970, month: 1, day: 1)
    }

    public static var today: Day {
        let components = todayComponents
        return Day(
            year: components.year ?? 0,
            month: components.month ?? 0,
            day: components.day ?? 0
        )
    }
    
    public static var yesterday: Day {
        let components = yesterdayComponents
        return Day(
            year: components.year ?? 0,
            month: components.month ?? 0,
            day: components.day ?? 0
        )
    }
    
    private static var todayComponents: DateComponents {
        Calendar.current.dateComponents([.day, .month, .year], from: Date())
    }
    
    private static var yesterdayComponents: DateComponents {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return Calendar.current.dateComponents([.day, .month, .year], from: yesterday ?? Date())
    }
    
    public static func lastDaysOfMonths(year: Int) -> [Int: Int] {
        var result: [Int:Int] = [:]
        for month in 1...12 {
            var days: Int = (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0) ? 29 : 28
            if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 {
                days = 31
            } else if month == 4 || month == 6 || month == 9 || month == 11 {
                days = 30
            }
            result[month] = days
        }
        return result
    }
    
    private static func twoDigitString(_ value: Int) -> String {
        String(format: "%02d", value)
    }
}
