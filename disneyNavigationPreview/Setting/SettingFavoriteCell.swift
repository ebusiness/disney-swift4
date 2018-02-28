//
//  SettingFavoriteCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/02/28.
//  Copyright © 2018 ebuser. All rights reserved.
//

import UIKit

class SettingFavoriteCell: UITableViewCell {

    let backgroundWhite: UIView
    let thumView: LeftRoundedCornerImageView
    let titleLabel: UILabel
    let parkLabel: UILabel
    let colorSymbol: UIView

    var data: Favorite? {
        didSet {
            if let data = data {
                if let imagePath = data.thum, let url = ImageAccessUrl(string: imagePath) {
                    thumView.af_setImage(withURLRequest: url)
                }
                titleLabel.text = data.name
                parkLabel.text = data.area
                if let hexColor = data.tintColor {
                    colorSymbol.backgroundColor = UIColor(hex: hexColor)
                }

            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        backgroundWhite = UIView()
        thumView = LeftRoundedCornerImageView(frame: .zero, cornerRadius: 2)
        titleLabel = UILabel(frame: .zero)
        parkLabel = UILabel(frame: .zero)
        colorSymbol = UIView(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = GlobalColor.viewBackgroundLightGray
        addSubBackground()
        addSubThumView()
        addSubTitleLabel()
        addSubColorSymbol()
        addSubParkLabel()
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
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: thumView.rightAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: backgroundWhite.topAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: backgroundWhite.rightAnchor, constant: -8).isActive = true
    }

    private func addSubColorSymbol() {
        addSubview(colorSymbol)
        colorSymbol.translatesAutoresizingMaskIntoConstraints = false
        colorSymbol.leftAnchor.constraint(equalTo: thumView.rightAnchor, constant: 8).isActive = true
        colorSymbol.bottomAnchor.constraint(equalTo: backgroundWhite.bottomAnchor, constant: -8).isActive = true
        colorSymbol.widthAnchor.constraint(equalToConstant: 3).isActive = true
    }

    private func addSubParkLabel() {
        parkLabel.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(parkLabel)
        parkLabel.translatesAutoresizingMaskIntoConstraints = false
        parkLabel.leftAnchor.constraint(equalTo: colorSymbol.rightAnchor, constant: 2).isActive = true
        parkLabel.bottomAnchor.constraint(equalTo: backgroundWhite.bottomAnchor, constant: -8).isActive = true
        colorSymbol.heightAnchor.constraint(equalTo: parkLabel.heightAnchor).isActive = true
    }

}
