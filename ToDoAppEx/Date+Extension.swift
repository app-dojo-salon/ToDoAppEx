//
//  Date+Extension.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/07/24.
//

import UIKit

extension Date {
    func toStringWithCurrentLocale() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
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
