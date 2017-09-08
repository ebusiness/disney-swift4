//
//  BaseInfoTagCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/8.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class BaseInfoTagCell: UICollectionViewCell {
    var visitorTag: VisitorTag? {
        didSet {
            if let tag = visitorTag {
                contentLabel.text = tag.name
                backgroundColor = UIColor(hex: tag.color)
            }
        }
    }

    private var contentLabel: UILabel
    override init(frame: CGRect) {

        contentLabel = UILabel()
        super.init(frame: frame)

        layer.cornerRadius = frame.size.height / 2

        contentLabel.textColor = UIColor.white
        contentLabel.font = UIFont.boldSystemFont(ofSize: 13)
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseInfoHeaderCell: UICollectionReusableView {

    var title = "" {
        didSet {
            textLabel.text = title
        }
    }

    private let textLabel: UILabel

    override init(frame: CGRect) {

        textLabel = UILabel()

        super.init(frame: frame)

        backgroundColor = BaseInfoColor.baseInfoHeaderCellBackground

        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        textLabel.textColor = UIColor.black
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
