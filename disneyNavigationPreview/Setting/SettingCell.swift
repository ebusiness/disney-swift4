//
//  SettingCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/29.
//  Copyright © 2018 ebuser. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell, Localizable {

    let localizeFileName = "Setting"

    var cellType: SettingCellType = .alert {
        didSet {
            switch cellType {
            case .alert:
                imageView?.tintColor = UIColor.red
                imageView?.image = #imageLiteral(resourceName: "ic_alarm_black_24px")
                textLabel?.text = localize(for: "Alert")
            }
        }
    }

}

enum SettingCellType {
    case alert
}
