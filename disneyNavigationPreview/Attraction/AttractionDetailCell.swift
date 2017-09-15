//
//  AttractionDetailCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/14.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class AttractionDetailImageCell: UITableViewCell {

    let pageController: UIPageViewController

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        pageController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.yellow
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
