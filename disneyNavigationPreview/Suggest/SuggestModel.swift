//
//  SuggestModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/20.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
struct SuggestPlan: Codable {
    let _id: String
    let introduction: String
    let name: String
    let route: [Route]
}

extension SuggestPlan {

    struct Route: Codable {
        let distanceToNext: Int
        let str_id: String
        let timeCost: Int
        let waitTime: Int
        let walktimeToNext: Int
        let attraction: Attraction
        let schedule: Schedule
    }

}

extension SuggestPlan.Route {

    struct Attraction: Codable {
        let category: String
        let images: [String]
        let is_available: Bool
        let name: String
    }

    struct Schedule: Codable {
        let startTime: String
        let endTime: String
    }

}
