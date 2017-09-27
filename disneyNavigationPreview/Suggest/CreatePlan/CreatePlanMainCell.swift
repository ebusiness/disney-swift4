//
//  CreatePlanMainCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/25.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import AlamofireImage
import UIKit

final class CreatePlanMainCell: UICollectionViewCell {

    var data: PlanListAttraction? {
        didSet {
            if let data = data {
                imageView.af_setImage(withURL: data.images[0])
                nameLabel.text = data.name
                areaLabel.text = data.area

                if data.selected {
                    check()
                } else {
                    uncheck()
                }
            }
        }
    }

    private let imageView: UIImageView
    private let nameLabel: UILabel
    private let areaBadge: UIView
    private let areaLabel: UILabel
    private let checkBox: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        nameLabel = UILabel(frame: .zero)
        areaBadge = UIView(frame: .zero)
        areaLabel = UILabel(frame: .zero)
        checkBox = UIImageView(frame: .zero)
        super.init(frame: frame)
        backgroundColor = UIColor.white

        addSubImageView()
        addSubCheckbox()
        addSubNameLabel()
        addSubAreaLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    private func addSubCheckbox() {
        checkBox.tintColor = GlobalColor.seperatorGray
        checkBox.image = #imageLiteral(resourceName: "checkbox_blank")
        addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkBox.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }

    private func addSubNameLabel() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12).isActive = true
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: checkBox.leftAnchor, constant: -6).isActive = true
    }

    private func addSubAreaLabel() {
        areaBadge.layer.cornerRadius = 1
        areaBadge.backgroundColor = UIColor.blue
        addSubview(areaBadge)
        areaBadge.translatesAutoresizingMaskIntoConstraints = false
        areaBadge.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        areaBadge.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        areaBadge.heightAnchor.constraint(equalToConstant: 10).isActive = true
        areaBadge.widthAnchor.constraint(equalToConstant: 2).isActive = true

        areaLabel.font = UIFont.boldSystemFont(ofSize: 10)
        addSubview(areaLabel)
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.centerYAnchor.constraint(equalTo: areaBadge.centerYAnchor).isActive = true
        areaLabel.leftAnchor.constraint(equalTo: areaBadge.rightAnchor, constant: 4).isActive = true
    }

    func setCheckboxHidden(_ hidden: Bool) {
        checkBox.isHidden = hidden
    }

    func check() {
        checkBox.tintColor = CreatePlanColor.checkboxChecked
        checkBox.image = #imageLiteral(resourceName: "checkbox_checked")
    }

    func uncheck() {
        checkBox.tintColor = CreatePlanColor.checkboxBlank
        checkBox.image = #imageLiteral(resourceName: "checkbox_blank")
    }
}
