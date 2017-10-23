//
//  GreetingCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/23.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class GreetingCell: UICollectionViewCell, Localizable {

    var data: Attraction? {
        didSet {
            if let imagePath = data?.images.first, let url = URL(string: imagePath) {
                myImageView.af_setImage(withURL: url)
            } else {
                myImageView.image = nil
            }

            if let name = data?.name {
                nameLabel.text = name
            } else {
                nameLabel.text = nil
            }

            if let area = data?.area {
                areaLabel.text = area
            } else {
                areaLabel.text = nil
            }
        }
    }

    let localizeFileName = "Attraction"

    private let myImageView: UIImageView
    fileprivate let footer: UIView

    fileprivate let nameContainer: UIView
    fileprivate let nameLabel: UILabel
    fileprivate let areaLabel: UILabel
    fileprivate let areaIcon: UIView

    override init(frame: CGRect) {
        myImageView = UIImageView(frame: .zero)
        footer = UIView(frame: .zero)

        nameContainer = UIView(frame: .zero)
        nameLabel = UILabel(frame: .zero)
        areaLabel = UILabel(frame: .zero)
        areaIcon = UIView(frame: .zero)

        super.init(frame: frame)
        addSubImageView()
        addSubFooter()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        myImageView.clipsToBounds = true
        myImageView.contentMode = .scaleAspectFill
        addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        myImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    fileprivate func addSubFooter() {
        footer.backgroundColor = UIColor.white
        addSubview(footer)
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        footer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        footer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        footer.heightAnchor.constraint(equalToConstant: 35).isActive = true

        addSubNameContainer()
    }

    fileprivate func addSubNameContainer() {
        addSubview(nameContainer)
        nameContainer.translatesAutoresizingMaskIntoConstraints = false
        nameContainer.leftAnchor.constraint(equalTo: footer.leftAnchor).isActive = true
        nameContainer.rightAnchor.constraint(equalTo: footer.rightAnchor).isActive = true
        nameContainer.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
        nameContainer.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true

        nameLabel.font = UIFont.boldSystemFont(ofSize: 10)
        nameContainer.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: nameContainer.leftAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: nameContainer.topAnchor, constant: 7).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: nameContainer.rightAnchor, constant: -12).isActive = true

        areaIcon.backgroundColor = UIColor.red
        areaIcon.layer.cornerRadius = 1
        areaIcon.layer.masksToBounds = true
        nameContainer.addSubview(areaIcon)
        areaIcon.translatesAutoresizingMaskIntoConstraints = false
        areaIcon.leftAnchor.constraint(equalTo: nameContainer.leftAnchor, constant: 12).isActive = true
        areaIcon.bottomAnchor.constraint(equalTo: nameContainer.bottomAnchor, constant: -5).isActive = true
        areaIcon.widthAnchor.constraint(equalToConstant: 2).isActive = true
        areaIcon.heightAnchor.constraint(equalToConstant: 8).isActive = true

        areaLabel.font = UIFont.boldSystemFont(ofSize: 8)
        nameContainer.addSubview(areaLabel)
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.leftAnchor.constraint(equalTo: areaIcon.rightAnchor, constant: 3).isActive = true
        areaLabel.bottomAnchor.constraint(equalTo: areaIcon.bottomAnchor).isActive = true
    }
}
