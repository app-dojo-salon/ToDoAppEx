//
//  Date+Extension.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/07/24.
//

import UIKit

extension Date {
    func toStringWithCurrentLocaleDay() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func toStringWithCurrentLocale() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }

    func toStringWithCurrentLocaleMillis() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: self)
    }


    /// 日付と引数の日付を比較して判定するメソッド
    /// - Parameter targetDay: 日付の比較対象
    /// - Returns: 比較対象の日付より前または同じ→true、比較対象より後→false
    func compareDate(targetDay: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let compareResult = targetDay.compare(self.toStringWithCurrentLocaleDay())

        switch compareResult {
        case .orderedAscending, .orderedSame:
            return true
        case .orderedDescending:
            return false
        }
    }

    func getIntervalDate(start: String, end: String) -> Int {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate: Date = formatter.date(from: start)!
        let endDate: Date = formatter.date(from: end)!
        guard let dayInterval = (Calendar.current.dateComponents([.day], from: startDate, to: endDate)).day else {
            return 0
        }

        return dayInterval
    }
}
