//
//  String+Extension.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2022/07/06.
//

import Foundation

extension String {
    func dateFromString(format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: self)!
    }
}
