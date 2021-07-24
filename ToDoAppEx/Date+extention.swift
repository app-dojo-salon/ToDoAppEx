//
//  Date+extention.swift
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
}
