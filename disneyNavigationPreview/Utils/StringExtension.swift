//
//  StringExtension.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/1.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

extension String {

    var utfData: Data? {
        return self.data(using: .utf8)
    }

    var htmlAttributedString: NSAttributedString? {

        guard let data = self.utfData else {
            return nil
        }

        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }

    }

}
