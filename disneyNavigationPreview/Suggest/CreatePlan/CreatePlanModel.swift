//
//  CreatePlanModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/22.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name

protocol PlanListAttractionCompatible {
    var str_id: String { get }
    var name: String { get }
    var images: [URL] { get }
    var area: String { get }
    var language: Language { get }
}

class PlanConfiguration {
    var park: TokyoDisneyPark

    // timezone(tokyo), year, month, day
    var date: DateComponents
    // timezone(tokyo), hour, minute
    var startTime: DateComponents
    // timezone(tokyo), hour, minute
    var endTime: DateComponents?

    init() {
        park = .land

        let now = Date()
        let components = Calendar.current.dateComponents(in: .tokyoTimezone, from: now)
        date = DateComponents()
        date.timeZone = .tokyoTimezone
        date.year = components.year
        date.month = components.month
        date.day = components.day! + 1

        startTime = DateComponents()
        startTime.timeZone = .tokyoTimezone
        startTime.hour = 10
        startTime.minute = 0
    }
}

class PlanListAttraction: PlanListAttractionCompatible {
    let str_id: String
    let name: String
    let images: [URL]
    let area: String
    let language: Language

    var selected = false

    init(_ attraction: PlanListAttractionCompatible) {
        self.str_id = attraction.str_id
        self.name = attraction.name
        self.images = Array(attraction.images)
        self.area = attraction.name
        self.language = attraction.language
    }
}

struct AttractionHotResponseData: Codable {
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

class AttractionHot: PlanListAttractionCompatible {
    let area: String
    let category: AttractionCategory
    let images: [URL]
    let score: Double
    let introductions: String
    let name: String
    let str_id: String
    let language = Preferences.language

    var selected = false

    init?(responseData: AttractionHotResponseData) {
        area = responseData.area

        guard let category = AttractionCategory(rawValue: responseData.category) else { return nil }
        self.category = category

        let images = responseData.images.flatMap({ URL(string: $0) })
        guard !images.isEmpty else { return nil }
        self.images = images

        let intScore = responseData.index_hot
        guard intScore > 0 else { return nil }
        let c = 4.0577
        let score = log(Double(intScore)) / log(c)
        self.score = score

        self.introductions = responseData.introductions

        self.name = responseData.name

        self.str_id = responseData.str_id
    }
}
