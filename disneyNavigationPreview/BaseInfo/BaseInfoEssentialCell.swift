//
//  BaseInfoEssentialCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class BaseInfoEssentialCell: UICollectionViewCell, Localizable {
    var localizeFileName = "BaseInfo"

    var spec: Spec? {
        didSet {
            guard let spec = spec else {
                return
            }
            switch spec {
            case let .date(date):
                backgroundColor = UIColor(red: 66, green: 129, blue: 215)
                imageView.image = #imageLiteral(resourceName: "baseinfo_date")
                title.text = localize(for: "chooseDate")
                content.textColor = UIColor(red: 28, green: 81, blue: 153)
                content.text = DateFormatter.localizedString(from: date,
                                                             dateStyle: .medium,
                                                             timeStyle: .none)
            case let .park(park):
                backgroundColor = UIColor(red: 255, green: 121, blue: 121)
                imageView.image = #imageLiteral(resourceName: "baseinfo_park")
                title.text = localize(for: "choosePark")
                content.textColor = UIColor(red: 212, green: 65, blue: 65)
                content.text = park.localize()
            }
        }
    }

    private let imageView: UIImageView
    private let title: UILabel
    private let content: UILabel

    override init(frame: CGRect) {
        imageView = UIImageView()
        title = UILabel()
        content = UILabel()
        super.init(frame: frame)

        addSubImageView()
        addSubTitle()
        addSubContent()

        layer.cornerRadius = 8
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        imageView.tintColor = UIColor.white
        imageView.contentMode = .center
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -25).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    private func addSubTitle() {
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 18)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5).isActive = true
    }

    private func addSubContent() {
        content.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30).isActive = true
    }

    enum Spec {
        case date(_: Date)
        case park(_: TokyoDisneyPark)
    }
}
