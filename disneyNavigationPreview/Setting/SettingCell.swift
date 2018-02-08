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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellType: SettingCellType = .alert {
        didSet {
            switch cellType {
            case .alert:
                imageView?.tintColor = UIColor.red
                imageView?.image = #imageLiteral(resourceName: "ic_alarm_black_24px")
                textLabel?.text = localize(for: "Alert")

            case .alertAdvance:
                imageView?.tintColor = UIColor.orange
                imageView?.image = #imageLiteral(resourceName: "ic_event_black_24px")
                textLabel?.text = localize(for: "Alert Advance")
                detailTextLabel?.text = localize(for: "Alert Advance \(UserDefaultUtils.getAlertAdvanceTime().rawValue)")
            }
        }
    }

}

enum SettingCellType {
    case alert
    case alertAdvance
}
