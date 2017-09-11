//
//  BaseInfoNavigationController.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class BaseInfoNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = GlobalColor.primaryRed
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
