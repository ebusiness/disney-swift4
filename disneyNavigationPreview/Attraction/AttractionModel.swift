//
//  AttractionModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/11.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
struct Attraction: Codable {

    let area: String
    let category: String
    let images: [String]
    let introductions: String
    let is_available: Bool
    let is_must_book: Bool?
    let name: String
    let note: String?
    let str_id: String
    let realtime: AttractionRealtime?

}

struct AttractionRealtime: Codable {

    let available: Bool
    let createTime: String
    let fastpassAvailable: Bool
    let operation_end: String?
    let operation_start: String?
    let statusInfo: String
    let str_id: String
    let updateTime: String
    let waitTime: Int?

}

class AttractionDetailBase: Codable {
    let str_id: String
    let category: String
    let area: String
    let images: [String]
    let introductions: String
    let is_available: Bool
    let name: String
    let note: String
}

class GreetingDetail: AttractionDetailBase {

    let summary_tags: [SummaryTag]

    enum CodingKeys: String, CodingKey {
        case summaryTags = "summary_tags"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        summary_tags = try values.decode([SummaryTag].self, forKey: .summaryTags)
        try super.init(from: decoder)
    }

    class SummaryTag: Codable {
        let tags: [String]
        let type: String
    }
}
