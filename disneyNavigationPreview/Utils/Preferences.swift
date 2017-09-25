//
//  Preferences.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/25.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

class Preferences {
    static let language: Language = {
        guard let syslang = NSLocale.preferredLanguages.first else {
            return .en
        }

        if syslang.hasPrefix("ja") {
            return .ja
        } else if syslang.hasPrefix("zh-Hant") {
            return .tw
        } else if syslang.hasPrefix("zh-Hans") {
            return .cn
        } else {
            return .en
        }
    }()
}
