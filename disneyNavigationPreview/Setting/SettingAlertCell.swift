//
//  SettingAlertCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/02/01.
//  Copyright © 2018 ebuser. All rights reserved.
//

import AlamofireImage
import UIKit

class SettingAlertCell: UITableViewCell {

    let backgroundWhite: UIView
    let thumView: LeftRoundedCornerImageView
    let titleLabel: UILabel
    let timeLabel: UILabel

    var data: Alarm? {
        didSet {
            if let data = data {
                if let imagePath = data.thum, let url = ImageAccessUrl(string: imagePath) {
                    thumView.af_setImage(withURLRequest: url)
                }
                titleLabel.text = data.name
                if let time = data.time {
                    timeLabel.text = DateFormatter.localizedString(from: time, dateStyle: .none, timeStyle: .short)
                }
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        backgroundWhite = UIView()
        thumView = LeftRoundedCornerImageView(frame: .zero, cornerRadius: 2)
        titleLabel = UILabel(frame: .zero)
        timeLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = GlobalColor.viewBackgroundLightGray
        addSubBackground()
        addSubThumView()
        addSubTitleLabel()
        addSubTimeLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubBackground() {
        backgroundWhite.backgroundColor = UIColor.white
        backgroundWhite.layer.cornerRadius = 2
        backgroundWhite.layer.masksToBounds = true
        addSubview(backgroundWhite)
        backgroundWhite.translatesAutoresizingMaskIntoConstraints = false
        backgroundWhite.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        backgroundWhite.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        backgroundWhite.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        backgroundWhite.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
    }

    private func addSubThumView() {
        addSubview(thumView)
        thumView.translatesAutoresizingMaskIntoConstraints = false
        thumView.leftAnchor.constraint(equalTo: backgroundWhite.leftAnchor).isActive = true
        thumView.topAnchor.constraint(equalTo: backgroundWhite.topAnchor).isActive = true
        thumView.bottomAnchor.constraint(equalTo: backgroundWhite.bottomAnchor).isActive = true
        thumView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }

    private func addSubTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: thumView.rightAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: backgroundWhite.topAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: backgroundWhite.rightAnchor, constant: -8).isActive = true
    }

    private func addSubTimeLabel() {
        timeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: backgroundWhite.bottomAnchor, constant: -8).isActive = true
    }

}
