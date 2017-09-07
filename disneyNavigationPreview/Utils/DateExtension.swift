//
//  DateExtension.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/7.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

extension Date {
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
}
