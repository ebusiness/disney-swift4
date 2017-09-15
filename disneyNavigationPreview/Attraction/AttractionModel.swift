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

struct AttractionDetail: Codable {
    let str_id: String
    let category: String
    let area: String
    let images: [String]
    let introductions: String
    let is_available: Bool
    let name: String
    let note: String
}
