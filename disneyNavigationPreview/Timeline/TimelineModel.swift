//
//  TimelineModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/09.
//  Copyright © 2017 ebuser. All rights reserved.
//

import Foundation

struct ShowTimeline: Codable {
    let id: String
    let area: String
    let name: String
    let schedules: [Schedule]

    enum CodingKeys: CodingKey, String {
        case id = "str_id"
        case area
        case name
        case schedules
    }

    struct Schedule: Codable {
        let startTime: String
        let endTime: String
    }
}
