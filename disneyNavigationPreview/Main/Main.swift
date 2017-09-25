//
//  Main.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/8.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barStyle = .black
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = GlobalColor.primaryRed
        navigationBar.tintColor = UIColor.white

        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewControllers.first == viewController {
            interactivePopGestureRecognizer?.isEnabled = false
        } else {
            interactivePopGestureRecognizer?.isEnabled = true
        }
    }

}

class TabVC: UITabBarController, Localizable {

    let localizeFileName = "Main"

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barStyle = .black
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = GlobalColor.primaryRed

        let suggestVC = SuggestVC()
        suggestVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_suggest")
        suggestVC.tabBarItem.title = localize(for: "TabbarSuggest")
        let suggestNavi = NavigationVC(rootViewController: suggestVC)

        let attractionVC = AttractionVC()
        attractionVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_attraction")
        attractionVC.tabBarItem.title = localize(for: "TabbarAttraction")
        let attractionNavi = NavigationVC(rootViewController: attractionVC)

        let myPlanVC = MyPlanVC()
        myPlanVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_myplan")
        myPlanVC.tabBarItem.title = localize(for: "TabbarMyPlan")
        let myPlanNavi = NavigationVC(rootViewController: myPlanVC)

        let settingVC = SettingVC()
        settingVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_setting")
        settingVC.tabBarItem.title = localize(for: "TabbarSetting")
        let settingNavi = NavigationVC(rootViewController: settingVC)

        let vcs = [suggestNavi, attractionNavi, myPlanNavi, settingNavi]
        setViewControllers(vcs, animated: false)
    }

}
