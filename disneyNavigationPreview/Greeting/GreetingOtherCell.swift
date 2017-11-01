//
//  GreetingOtherCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/31.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class GreetingOtherCell: UICollectionViewCell {

    var payload: AnalysedGreetingDetail.Payload? {
        didSet {
            titleLabel.text = payload?.title
            textLabel.text = payload?.content
        }
    }

    private let icon: UIImageView
    private let titleLabel: UILabel
    private let textLabel: UILabel

    override init(frame: CGRect) {
        icon = UIImageView(frame: .zero)
        titleLabel = UILabel()
        textLabel = UILabel()
        super.init(frame: frame)

        backgroundColor = UIColor.white

        addSubIcon()
        addSubTitleLabel()
        addSubTextLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubIcon() {
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 44).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func addSubTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: icon.topAnchor).isActive = true
    }

    private func addSubTextLabel() {
        textLabel.font = UIFont.systemFont(ofSize: 11)
        textLabel.textColor = GlobalColor.grayText
        textLabel.numberOfLines = 0
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        textLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }

}
