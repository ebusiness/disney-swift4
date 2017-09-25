//
//  CreatePlanModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/22.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
struct AttractionHot: Codable {
    let area: String
    let category: String
    let images: [String]
    let index_hot: Int
    let introductions: String
    let is_available: Bool
    let name: String
    let note: String?
    let str_id: String
    let realtime: AttractionRealtime?
}
