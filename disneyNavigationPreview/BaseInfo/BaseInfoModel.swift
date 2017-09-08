//
//  BaseInfoModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/8.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

struct VisitorTag: Codable {
    let id: String
    let color: String
    let name: String

    private var cellSizeHolder: CGSize? = nil //swiftlint:disable:this redundant_optional_initialization
    mutating func getCellSize() -> CGSize {
        if let size = cellSizeHolder {
            return size
        } else {
            let string = name as NSString
            let stringSize = string.size(withAttributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13)])
            let cellSize = CGSize(width: stringSize.width + 30,
                                  height: stringSize.height + 12)
            cellSizeHolder = cellSize
            return cellSize
        }
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case color
        case name
    }
}
