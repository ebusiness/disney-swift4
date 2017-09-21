//
//  SuggestCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/20.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import AlamofireImage
import UIKit

class SuggestCell: UICollectionViewCell {

    var planData: SuggestPlan? {
        didSet {
            if let plan = planData {
                if let imagePath = plan.route.first?.attraction.images.first, let url = URL(string: imagePath) {
                    imageView.af_setImage(withURL: url)
                } else {
                    imageView.image = nil
                }

                titleLabel.text = plan.name
                detailTitleLabel.text = plan.introduction
            }
        }
    }

    let imageView: UIImageView
    let bottomContainer: UIView
    let authorAvatar: UIImageView
    let titleLabel: UILabel
    let detailTitleLabel: UILabel
    let seperator: UIView
    let heart: UIImageView
    let likeLabel: UILabel

    override init(frame: CGRect) {

        imageView = UIImageView(frame: .zero)
        bottomContainer = UIView(frame: .zero)
        authorAvatar = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        detailTitleLabel = UILabel(frame: .zero)
        seperator = UIView(frame: .zero)
        heart = UIImageView(image: #imageLiteral(resourceName: "heart"))
        likeLabel = UILabel(frame: .zero)
        super.init(frame: frame)

        backgroundColor = UIColor.white
        addSubImageView()
        addSubBottomContainer()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }

    private func addSubImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    private func addSubBottomContainer() {
        addSubview(bottomContainer)
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 65).isActive = true

        authorAvatar.layer.cornerRadius = 16.5
        authorAvatar.layer.masksToBounds = true
        let url = URL(string: "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/e1/e1ac7f505c0ddd7852a62626840386aa66886274.jpg")!
        authorAvatar.af_setImage(withURL: url)
        bottomContainer.addSubview(authorAvatar)
        authorAvatar.translatesAutoresizingMaskIntoConstraints = false
        authorAvatar.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
        authorAvatar.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor, constant: 16).isActive = true
        authorAvatar.heightAnchor.constraint(equalToConstant: 33).isActive = true
        authorAvatar.widthAnchor.constraint(equalToConstant: 33).isActive = true

        addSubBottomRight()

        titleLabel.font = UIFont.systemFont(ofSize: 17)
        bottomContainer.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: authorAvatar.rightAnchor, constant: 16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomContainer.centerYAnchor, constant: -2).isActive = true

        detailTitleLabel.font = UIFont.systemFont(ofSize: 12)
        detailTitleLabel.textColor = SuggestColor.cellTextLight
        bottomContainer.addSubview(detailTitleLabel)
        detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        detailTitleLabel.topAnchor.constraint(equalTo: bottomContainer.centerYAnchor, constant: 4).isActive = true
    }

    private func addSubBottomRight() {

        let bottomRight = UIView(frame: .zero)
        bottomContainer.addSubview(bottomRight)
        bottomRight.translatesAutoresizingMaskIntoConstraints = false
        bottomRight.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        bottomRight.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor).isActive = true
        bottomRight.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor).isActive = true
        bottomRight.widthAnchor.constraint(equalToConstant: 95).isActive = true

        seperator.backgroundColor = SuggestColor.verticalSeperator
        bottomRight.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.bottomAnchor.constraint(equalTo: bottomRight.bottomAnchor).isActive = true
        seperator.leftAnchor.constraint(equalTo: bottomRight.leftAnchor).isActive = true
        seperator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 50).isActive = true

        heart.tintColor = GlobalColor.primaryRed
        bottomRight.addSubview(heart)
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.centerXAnchor.constraint(equalTo: bottomRight.centerXAnchor).isActive = true
        heart.centerYAnchor.constraint(equalTo: bottomRight.centerYAnchor, constant: -8).isActive = true

        likeLabel.font = UIFont.systemFont(ofSize: 12)
        likeLabel.textColor = SuggestColor.cellTextLight
        likeLabel.text = "3000 收藏"
        bottomRight.addSubview(likeLabel)
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.centerXAnchor.constraint(equalTo: bottomRight.centerXAnchor).isActive = true
        likeLabel.topAnchor.constraint(equalTo: bottomRight.centerYAnchor, constant: 4).isActive = true

    }

}
