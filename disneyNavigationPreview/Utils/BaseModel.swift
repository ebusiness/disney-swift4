//
//  BaseModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

//swiftlint:disable identifier_name
enum TokyoDisneyPark: String, Localizable {
    case land
    case sea

    var localizeFileName: String {
        return "BaseModel"
    }

    func localize() -> String {
        switch self {
        case .land:
            return localize(for: "TokyoDisneyPark.land")
        case.sea:
            return localize(for: "TokyoDisneyPark.sea")
        }
    }
}

enum AttractionCategory: String {
    case attraction
    case greeting
    case show
}

enum Language: String {
    case cn
    case en
    case ja
    case tw
}
