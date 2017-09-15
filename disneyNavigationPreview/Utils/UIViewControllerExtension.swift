//
//  UIViewControllerExtension.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/15.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

extension UIViewController {

    var titleOfPreviousViewController: String? {
        guard let navigationController = navigationController else { return nil }
        guard let index = navigationController.viewControllers.index(of: self), index > 0 else { return nil }
        return navigationController.viewControllers[index - 1].title
    }

}
