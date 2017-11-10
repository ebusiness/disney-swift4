//
//  BaseModel.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

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

    var apiComponent: String {
        switch self {
        case .land:
            return "land/"
        case .sea:
            return "sea/"
        }
    }
}

enum ParkArea: String {
    case tomorrowland
    case toontown
    case fantasyland
    case westernland
    case worldBazaar
    case parkwide
    case adventureland
    case critterCountry

    case mermaidLagoon
    case mysteriousIsland
    case lostRiverDelta
    case arabianCoast
    case mediterraneanHarbor
    case americanWaterfront
    case portDiscovery
    case entrance

    private static let tomorrowlandSet = Set(["Tomorrowland", "明日乐园", "トゥモローランド", "明日樂園"])
    private static let toontownSet = Set(["Toontown", "卡通城", "トゥーンタウン", "卡通城"])
    private static let fantasylandSet = Set(["Fantasyland", "梦幻乐园", "ファンタジーランド", "夢幻樂園"])
    private static let westernlandSet = Set(["Westernland", "西部乐园", "ウエスタンランド", "西部樂園"])
    private static let worldBazaarSet = Set(["World Bazaar", "世界市集", "ワールドバザール", "世界市集"])
    private static let parkwideSet = Set(["Park-wide", "园区全域", "パークワイド", "園區全域"])
    private static let adventurelandSet = Set(["Adventureland", "探险乐园", "アドベンチャーランド", "探險樂園"])
    private static let critterCountrySet = Set(["Critter Country", "动物天地", "クリッターカントリー", "動物天地"])

    private static let mermaidLagoonSet = Set(["Mermaid Lagoon", "美人鱼礁湖", "マーメイドラグーン", "美人魚礁湖"])
    private static let mysteriousIslandSet = Set(["Mysterious Island", "神秘岛", "ミステリアスアイランド", "神祕島"])
    private static let lostRiverDeltaSet = Set(["Lost River Delta", "失落河三角洲", "ロストリバーデルタ", "失落河三角洲"])
    private static let arabianCoastSet = Set(["Arabian Coast", "阿拉伯海岸", "アラビアンコースト", "阿拉伯海岸"])
    private static let mediterraneanHarborSet = Set(["Mediterranean Harbor", "地中海港湾", "メディテレーニアンハーバー", "地中海港灣"])
    private static let americanWaterfrontSet = Set(["American Waterfront", "美国海滨", "アメリカンウォーターフロント", "美國海濱"])
    private static let portDiscoverySet = Set(["Port Discovery", "发现港", "ポートディスカバリー", "發現港"])
    private static let entranceSet = Set(["Entrance", "入园口", "エントランス", "入園口"])

    //swiftlint:disable statement_position
    init?(rawValue: String) {
        if ParkArea.tomorrowlandSet.contains(rawValue) { self = .tomorrowland }
        else if ParkArea.toontownSet.contains(rawValue) { self = .toontown }
        else if ParkArea.fantasylandSet.contains(rawValue) { self = .fantasyland }
        else if ParkArea.westernlandSet.contains(rawValue) { self = .westernland }
        else if ParkArea.worldBazaarSet.contains(rawValue) { self = .worldBazaar }
        else if ParkArea.parkwideSet.contains(rawValue) { self = .parkwide }
        else if ParkArea.adventurelandSet.contains(rawValue) { self = .adventureland }
        else if ParkArea.critterCountrySet.contains(rawValue) { self = .critterCountry }
        else if ParkArea.mermaidLagoonSet.contains(rawValue) { self = .mermaidLagoon }
        else if ParkArea.mysteriousIslandSet.contains(rawValue) { self = .mysteriousIsland }
        else if ParkArea.lostRiverDeltaSet.contains(rawValue) { self = .lostRiverDelta }
        else if ParkArea.arabianCoastSet.contains(rawValue) { self = .arabianCoast }
        else if ParkArea.mediterraneanHarborSet.contains(rawValue) { self = .mediterraneanHarbor }
        else if ParkArea.americanWaterfrontSet.contains(rawValue) { self = .americanWaterfront }
        else if ParkArea.portDiscoverySet.contains(rawValue) { self = .portDiscovery }
        else if ParkArea.entranceSet.contains(rawValue) { self = .entrance }
        else { return nil }
    }
    //swiftlint:enable statement_position
}

extension ParkArea {
    var tintColor: UIColor {
        switch self {
        case .tomorrowland:
            return UIColor(hex: "3F51B5")
        case .toontown:
            return UIColor(hex: "FF9800")
        case .fantasyland:
            return UIColor(hex: "673AB7")
        case .westernland:
            return UIColor(hex: "795548")
        case .worldBazaar:
            return UIColor(hex: "E91E63")
        case .adventureland:
            return UIColor(hex: "4CAF50")
        case .critterCountry:
            return UIColor(hex: "03A9F4")
        case .mermaidLagoon:
            return UIColor(hex: "E91E63")
        case .mysteriousIsland:
            return UIColor(hex: "009688")
        case .lostRiverDelta:
            return UIColor(hex: "4CAF50")
        case .arabianCoast:
            return UIColor(hex: "673AB7")
        case .mediterraneanHarbor:
            return UIColor(hex: "FF5722")
        case .americanWaterfront:
            return UIColor(hex: "D50000")
        case .portDiscovery:
            return UIColor(hex: "FFC107")
        default:
            return GlobalColor.primaryRed
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
