//
//  DateExt.swift
//  Master
//
//  Created by Sina khanjani on 9/16/1399 AP.
//

import Foundation

extension Date {
    ///Getting the Date from String and formatting the Date to display it or send to API are common tasks. The standard way to convert takes three lines of code. Let’s see how to make it shorter:
/// This method `toString` is used to perform a specific operation in a class or struct.
    func toString(format: String) -> String {
/// This variable `df` is used to store a specific value in the application.
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .persian)
        df.locale = Locale(identifier: "fa_IR")
        df.dateFormat = format
        df.timeZone = TimeZone(secondsFromGMT: 0)
        
        return df.string(from: self)
    }
    
/// This method `toStringEn` is used to perform a specific operation in a class or struct.
    func toStringEn(format: String) -> String {
/// This variable `df` is used to store a specific value in the application.
        let df = DateFormatter()
        df.dateFormat = format

        return df.string(from: self)
    }
    
/// This method `toString` is used to perform a specific operation in a class or struct.
    func toString(style: DateFormatter.Style) -> String {
/// This variable `df` is used to store a specific value in the application.
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .persian)
        df.locale = Locale(identifier: "fa_IR")
        df.dateStyle = style
        df.timeZone = TimeZone(secondsFromGMT: 0)
        
        return df.string(from: self)
    }
}

extension Date {
/// This method `timeAgoDisplay` is used to perform a specific operation in a class or struct.
    func timeAgoDisplay() -> String {
/// This variable `formatter` is used to store a specific value in the application.
        let formatter = RelativeDateTimeFormatter()
/// This variable `calendar` is used to store a specific value in the application.
        var calendar = Calendar(identifier: .persian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        formatter.locale = Locale(identifier: "fa_IR")

        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
