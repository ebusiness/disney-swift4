//
//  Localize.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

protocol Localizable {
    var localizeFileName: String { get }
}

extension Localizable {
    func localize(for key: String, arguments: CVarArg...) -> String {
        if arguments.isEmpty {
            return NSLocalizedString(key,
                                     tableName: localizeFileName,
                                     comment: "")
        } else {
            let nonArgs = self.localize(for: key)
            return String(format: nonArgs, arguments: Array(arguments))
        }
    }
}
