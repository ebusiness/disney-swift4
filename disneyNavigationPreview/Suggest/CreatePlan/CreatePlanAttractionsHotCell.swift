//
//  CreatePlanAttractionsHotCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/22.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import AlamofireImage
import UIKit

final class CreatePlanAttractionsHotCell: UICollectionViewCell {

    var data: AttractionHot? {
        didSet {
            if let data = data {
                if let urlString = data.images.first, let url = URL(string: urlString) {
                    imageView.af_setImage(withURL: url)
                }
                titleLabel.text = data.name
            }
        }
    }

    private let card: UIImageView
    private let imageView: UIImageView
    private let titleLabel: UILabel
    private let checkBox: UIImageView

    override init(frame: CGRect) {
        card = UIImageView(frame: .zero)
        imageView = TopRoundedCornerImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        checkBox = UIImageView(frame: .zero)
        super.init(frame: frame)

        addSubCard()
        addSubImageView()
        addSubCheckBox()
        addSubTitleLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubCard() {
        card.image = #imageLiteral(resourceName: "card")
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        card.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        card.topAnchor.constraint(equalTo: topAnchor).isActive = true
        card.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private func addSubImageView() {
        imageView.contentMode = .scaleAspectFill
        card.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 5.7).isActive = true
        imageView.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -6).isActive = true
        imageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 4.5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 133).isActive = true
    }

    private func addSubCheckBox() {
        addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        checkBox.rightAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
    }

    private func addSubTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: checkBox.leftAnchor, constant: -8).isActive = true
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
