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
            }
        }
    }

    private let movableView: UIView
    private let imageView: UIImageView
    private let nameLabel: UILabel
    private let areaBadge: UIView
    private let areaLabel: UILabel
    private let closeButton: UIButton

    override init(frame: CGRect) {
        movableView = UIView(frame: .zero)
        imageView = UIImageView(frame: .zero)
        nameLabel = UILabel(frame: .zero)
        areaBadge = UIView(frame: .zero)
        areaLabel = UILabel(frame: .zero)
        closeButton = UIButton(type: .custom)
        super.init(frame: frame)
        backgroundColor = UIColor.white

        addSubMovableView()
        addSubImageView()
        addSubCloseButton()
        addSubNameLabel()
        addSubAreaLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubMovableView() {
        addSubview(movableView)
        movableView.translatesAutoresizingMaskIntoConstraints = false
        movableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        movableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        movableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        movableView.widthAnchor.constraint(equalToConstant: 30).isActive = true

        let movableImageView = UIImageView(image: #imageLiteral(resourceName: "movable"))
        movableImageView.tintColor = CreatePlanColor.movableIcon
        movableView.addSubview(movableImageView)
        movableImageView.translatesAutoresizingMaskIntoConstraints = false
        movableImageView.centerXAnchor.constraint(equalTo: movableView.centerXAnchor).isActive = true
        movableImageView.centerYAnchor.constraint(equalTo: movableView.centerYAnchor).isActive = true
    }

    private func addSubImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: movableView.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    private func addSubCloseButton() {
        closeButton.tintColor = GlobalColor.seperatorGray
        closeButton.setImage(#imageLiteral(resourceName: "ic_highlight_off_black_24px"), for: .normal)
        closeButton.setImage(#imageLiteral(resourceName: "ic_highlight_off_black_24px"), for: .highlighted)
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
    }

    private func addSubNameLabel() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12).isActive = true
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: closeButton.leftAnchor, constant: -6).isActive = true
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
}
