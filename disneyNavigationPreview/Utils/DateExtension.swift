//
//  DateExtension.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/7.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation
import UIKit

extension TimeZone {

    static let tokyoTimezone: TimeZone = {
        return TimeZone(abbreviation: "JST")!
    }()
    
}

extension Date {

    var dateStringInTokyo: String {
        let formatter = DateFormatter()
        formatter.timeZone = .tokyoTimezone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    var dateTimeStringInTokyo: String {
        let formatter = DateFormatter()
        formatter.timeZone = .tokyoTimezone
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return formatter.string(from: self)
    }

    var hourInTokyo: CGFloat? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(in: .tokyoTimezone, from: self)
        guard let hour = dateComponents.hour else { return nil }
        guard let minute = dateComponents.minute else { return nil }
        return CGFloat(hour) + CGFloat(minute) / 60
    }

    func numberOfDaysInMonth() -> Int? {
        let range = Calendar.current.range(of: .day, in: .month, for: self)
        return range?.count
    }

    func firstWeekdayInMonth() -> Int? {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        if let firstDayDate = Calendar.current.date(from: components) {
            return Calendar.current.component(.weekday, from: firstDayDate) - 1
        } else {
            return nil
        }
    }

    init?(iso8601str: String?) {
        guard let iso8601str = iso8601str else {
            return nil
        }
        let formatterA = DateFormatter()
        formatterA.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let formatterB = DateFormatter()
        formatterB.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if let date = formatterA.date(from: iso8601str) ?? formatterB.date(from: iso8601str) {
            self = date
        } else {
            return nil
        }
    }

}

extension DateComponents {

    func format(_ formatString: String) -> String {
        let date = Calendar.current.date(from: self)!
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        return formatter.string(from: date)
    }

    func systemFormat(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let date = Calendar.current.date(from: self)!
        return DateFormatter.localizedString(from: date, dateStyle: dateStyle, timeStyle: timeStyle)
    }

}
