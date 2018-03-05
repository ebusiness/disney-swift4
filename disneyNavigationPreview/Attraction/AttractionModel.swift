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
    let coordinates: [Double]?

}

struct AttractionRealtime: Codable {

    let available: Bool
    let createTime: String
    let fastpassAvailable: Bool
    let operation_end: String?
    let operation_start: String?
    let statusInfo: String?
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

class ShowDetail: AttractionDetailBase {
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

class AttractionDetail: AttractionDetailBase {
    let summary_tags: [SummaryTag]
    let summaries: [Summary]?
    let limited: [String]?

    enum CodingKeys: String, CodingKey {
        case summaryTags = "summary_tags"
        case summaries = "summaries"
        case limited = "limited"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        summary_tags = try values.decode([SummaryTag].self, forKey: .summaryTags)
        summaries = try? values.decode([Summary].self, forKey: .summaries)
        limited = try? values.decode([String].self, forKey: .limited)
        try super.init(from: decoder)
    }

    class SummaryTag: Codable {
        let tags: [String]
        let type: String
    }

    class Summary: Codable {
        let body: String
        let title: String
    }
}

struct WaitTime: Codable {
    let datetime: Date
    let prediction: [Prediction]
    let realtime: [RealTime]

    enum CodingKeys: String, CodingKey {
        case datetime, prediction, realtime
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        guard let datetime = try Date(iso8601str: values.decode(String.self, forKey: .datetime)) else {
            throw DecodeError.dateFormatError
        }
        self.datetime = datetime

        prediction = try values.decode([Prediction].self, forKey: .prediction)
        realtime = try values.decode([RealTime].self, forKey: .realtime)
    }

    struct Prediction: Codable {
        let at: Date
        let waitTime: Int

        // 从8:00至22:00每15分钟分割
        let index: Int

        enum CodingKeys: String, CodingKey {
            case at = "createTime"
            case waitTime = "waitTime"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let atString = try values.decode(String.self, forKey: .at)
            waitTime = try values.decode(Int.self, forKey: .waitTime)

            guard let atDate = Date(iso8601str: atString) else {
                throw DecodeError.dateFormatError
            }
            at = atDate

            guard let index = at.waitTimeIndex else {
                throw DecodeError.dateFormatError
            }
            self.index = index
        }
    }

    struct RealTime: Codable {
        let running: Bool
        let at: Date
        let operationEnd: Date?
        let waitTime: Int

        // 从8:00至22:00每15分钟分割
        let index: Int

        enum CodingKeys: String, CodingKey {
            case running = "available"
            case at = "createTime"
            case operationEnd = "operation_end"
            case waitTime = "waitTime"
        }

        init(from decoder: Decoder) throws {
            let value = try decoder.container(keyedBy: CodingKeys.self)

            guard let createTime = try Date(iso8601str: value.decode(String.self, forKey: .at)) else {
                throw DecodeError.dateFormatError
            }
            at = createTime

            running = try value.decode(Bool.self, forKey: .running)

            if running {
                waitTime = try value.decode(Int.self, forKey: .waitTime)
            } else {
                waitTime = 0
            }

            if let _operationEnd = try Date(iso8601str: value.decode(String.self, forKey: .operationEnd)) {
                operationEnd = _operationEnd
            } else {
                operationEnd = nil
            }

            guard let index = createTime.waitTimeIndex else {
                throw DecodeError.dateFormatError
            }
            self.index = index
        }
    }

    enum DecodeError: Error {
        case dateFormatError
    }
}
 extension Date {
    var waitTimeIndex: Int? {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: self)
        guard let hour = comp.hour, let minute = comp.minute else {
            return nil
        }
        let secondsSinceOpen = hour * 3600 + minute * 60 - 8 * 3600
        if secondsSinceOpen < 0 {
            return nil
        }
        let index = Int(floor( Double(secondsSinceOpen) / Double(60 * 15) ))
        if index > 56 {
            return nil
        } else {
            return index
        }
    }
}
