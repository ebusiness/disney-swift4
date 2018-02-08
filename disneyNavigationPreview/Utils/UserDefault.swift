//
//  UserDefault.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/02/08.
//  Copyright © 2018 ebuser. All rights reserved.
//

import Foundation

class UserDefaultUtils {

    static let kAlertAdvanceTime = "kAlertAdvanceTime"

    static func setAlertAdvanceTime(_ time: AlertAdvanceTime) {
        let defaults = UserDefaults.standard
        defaults.set(time.rawValue, forKey: kAlertAdvanceTime)
        defaults.synchronize()
    }

    static func getAlertAdvanceTime() -> AlertAdvanceTime {
        let defaults = UserDefaults.standard
        guard let value = defaults.value(forKey: kAlertAdvanceTime) as? Int else { return .before30 }
        return AlertAdvanceTime(rawValue: value) ?? .before30
    }
}

enum AlertAdvanceTime: Int {
    case just = 0
    case before5 = 5
    case before10 = 10
    case before15 = 15
    case before30 = 30
}
