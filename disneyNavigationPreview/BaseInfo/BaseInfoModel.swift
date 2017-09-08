//
//  BaseInfoModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/8.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

struct VisitorTag: Codable {
    let id: String
    let color: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case color
        case name
    }
}
