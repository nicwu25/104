//
//  DateUtility.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/14.
//

import Foundation

class DateUtility {
    
    static let dateFormatter = DateFormatter()

    var timeZone: TimeZone {
        return TimeZone(identifier: "Asia/Taipei") ?? TimeZone.current
    }
    
    static func getString(from date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateUtility.dateFormatter
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    static func getCreateTimeString(_ createTime: Double) -> String {
        let date = Date(timeIntervalSince1970: createTime)
        if date.isInToday {
            return "今日"
        }
        if date.isInYesterday {
            return "昨日"
        }
        if date.isInThisYear {
            return getString(from: date, format: "MM-dd")
        }
        return getString(from: date)
    }
}

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear: Bool { isInSameYear(as: Date()) }
    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
}
