//
//  BaseModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

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
