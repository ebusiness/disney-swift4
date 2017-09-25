//
//  CreatePlanCategoryCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/22.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class CreatePlanCategoryCell: UICollectionViewCell, Localizable {

    var type: Category? {
        didSet {
            if let type = type {
                switch type {
                case .hot:
                    imageView.image = #imageLiteral(resourceName: "at_category_hot")
                    titleLabel.text = localize(for: "CategoryHot")
                case .mode:
                    imageView.image = #imageLiteral(resourceName: "at_category_mode")
                    titleLabel.text = localize(for: "CategoryMode")
                case .area:
                    imageView.image = #imageLiteral(resourceName: "at_category_area")
                    titleLabel.text = localize(for: "CategoryArea")
                case .threeDimension:
                    imageView.image = #imageLiteral(resourceName: "at_category_threeDimension")
                    titleLabel.text = localize(for: "CategoryThreeDimension")
                case .rain:
                    imageView.image = #imageLiteral(resourceName: "at_category_rain")
                    titleLabel.text = localize(for: "CategoryRain")
                case .fastpass:
                    imageView.image = #imageLiteral(resourceName: "at_category_fastpass")
                    titleLabel.text = localize(for: "CategoryFastpass")
                case .heightFree:
                    imageView.image = #imageLiteral(resourceName: "at_category_heightFree")
                    titleLabel.text = localize(for: "CategoryHeightFree")
                case .baby:
                    imageView.image = #imageLiteral(resourceName: "at_category_baby")
                    titleLabel.text = localize(for: "CategoryBaby")
                case .thrill:
                    imageView.image = #imageLiteral(resourceName: "at_category_thrill")
                    titleLabel.text = localize(for: "CategoryThrill")
                }
            }
        }
    }

    let localizeFileName = "CreatePlan"

    private let imageView: UIImageView
    private let titleLabel: UILabel

    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        super.init(frame: frame)

        backgroundColor = UIColor.white
        addSubImageView()
        addSubTitleLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 11).isActive = true
    }

    private func addSubTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 14).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    enum Category: Int {
        case hot = 0
        case mode
        case area
        case threeDimension
        case rain
        case fastpass
        case heightFree
        case baby
        case thrill
    }

}
