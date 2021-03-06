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
            if let data = data, let imageRequest = ImageAccessUrl(url: data.images[0]) {
                imageView.af_setImage(withURLRequest: imageRequest)

                titleLabel.text = data.name

                scoreLabel.text = String(format: "%.1f", arguments: [data.score])

                if data.selected {
                    check()
                } else {
                    uncheck()
                }
            }
        }
    }

    private let card: UIImageView
    private let imageView: UIImageView
    private let titleLabel: UILabel
    private let checkBox: UIImageView
    private let scoreView: UIView
    private let scoreIcon: UIImageView
    private let scoreLabel: UILabel

    override init(frame: CGRect) {
        card = UIImageView(frame: .zero)
        imageView = TopRoundedCornerImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        checkBox = UIImageView(frame: .zero)
        scoreView = UIImageView(frame: .zero)
        scoreIcon = UIImageView(image: #imageLiteral(resourceName: "attraction_hot_icon"))
        scoreLabel = UILabel(frame: .zero)
        super.init(frame: frame)

        addSubCard()
        addSubImageView()
        addSubCheckBox()
        addSubTitleLabel()
        addSubScoreView()
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

    private func addSubScoreView() {
        scoreView.layer.cornerRadius = 9.5
        scoreView.backgroundColor = CreatePlanColor.attractionHotIconTint
        imageView.addSubview(scoreView)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 13).isActive = true
        scoreView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -7).isActive = true
        scoreView.heightAnchor.constraint(equalToConstant: 19).isActive = true
        scoreView.widthAnchor.constraint(equalToConstant: 49).isActive = true

        scoreIcon.tintColor = UIColor.white
        scoreView.addSubview(scoreIcon)
        scoreIcon.translatesAutoresizingMaskIntoConstraints = false
        scoreIcon.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor).isActive = true
        scoreIcon.leftAnchor.constraint(equalTo: scoreView.leftAnchor, constant: 8).isActive = true

        scoreLabel.textColor = UIColor.white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 12)
        scoreView.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerYAnchor.constraint(equalTo: scoreIcon.centerYAnchor).isActive = true
        scoreLabel.leftAnchor.constraint(equalTo: scoreIcon.rightAnchor, constant: 4).isActive = true
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
