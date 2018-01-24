//
//  ShowCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/20.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import AlamofireImage
import UIKit

class ShowCell: UICollectionViewCell, Localizable {

    var data: Attraction? {
        didSet {
            if let imagePath = data?.images.first, let url = ImageAccessUrl(string: imagePath) {
                myImageView.af_setImage(withURLRequest: url)
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

final class ShowCellReserve: ShowCell {
    private let reserveContainer: UIView
    private let reserveIcon: UIImageView
    private let reserveLabel: UILabel
    private let reserveSeperator: UIView

    override init(frame: CGRect) {
        reserveContainer = UIView(frame: .zero)
        reserveIcon = UIImageView(image: #imageLiteral(resourceName: "reserved_icon"))
        reserveLabel = UILabel(frame: .zero)
        reserveSeperator = UIView(frame: .zero)
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addSubFooter() {
        footer.backgroundColor = UIColor.white
        addSubview(footer)
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        footer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        footer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        footer.heightAnchor.constraint(equalToConstant: 35).isActive = true

        addSubReserveContainer()
        addSubNameContainer()
    }

    private func addSubReserveContainer() {
        footer.addSubview(reserveContainer)
        reserveContainer.translatesAutoresizingMaskIntoConstraints = false
        reserveContainer.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
        reserveContainer.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
        reserveContainer.rightAnchor.constraint(equalTo: footer.rightAnchor).isActive = true
        reserveContainer.widthAnchor.constraint(equalToConstant: 97).isActive = true

        reserveLabel.text = localize(for: "reserve")
        reserveLabel.font = UIFont.boldSystemFont(ofSize: 10)
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false

        reserveIcon.tintColor = UIColor(red: 255, green: 186, blue: 0)
        container.addSubview(reserveIcon)
        container.addSubview(reserveLabel)
        reserveIcon.translatesAutoresizingMaskIntoConstraints = false
        reserveLabel.translatesAutoresizingMaskIntoConstraints = false
        reserveIcon.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        reserveIcon.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        reserveIcon.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        reserveLabel.leftAnchor.constraint(equalTo: reserveIcon.rightAnchor, constant: 4).isActive = true
        reserveLabel.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        reserveLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        reserveContainer.addSubview(container)
        container.centerXAnchor.constraint(equalTo: reserveContainer.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: reserveContainer.centerYAnchor).isActive = true

        reserveSeperator.backgroundColor = UIColor(red: 196, green: 196, blue: 196)
        reserveContainer.addSubview(reserveSeperator)
        reserveSeperator.translatesAutoresizingMaskIntoConstraints = false
        reserveSeperator.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        reserveSeperator.bottomAnchor.constraint(equalTo: reserveContainer.bottomAnchor).isActive = true
        reserveSeperator.heightAnchor.constraint(equalToConstant: 19).isActive = true
        reserveSeperator.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }

    override func addSubNameContainer() {
        addSubview(nameContainer)
        nameContainer.translatesAutoresizingMaskIntoConstraints = false
        nameContainer.leftAnchor.constraint(equalTo: footer.leftAnchor).isActive = true
        nameContainer.rightAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
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
