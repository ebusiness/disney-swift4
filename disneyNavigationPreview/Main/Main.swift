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

class WhiteNavigationVC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barStyle = .black
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor.black
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

class TabVC: UITabBarController, Localizable {

    let localizeFileName = "Main"

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barStyle = .black
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = GlobalColor.primaryRed

        let attractionPageVC = AttractionPageVC()
        attractionPageVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_attraction")
        attractionPageVC.tabBarItem.title = localize(for: "TabbarAttraction")
        let attractionPageNavi = NavigationVC(rootViewController: attractionPageVC)

        let showScheduleVC = ShowScheduleVC()
        showScheduleVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_show")
        showScheduleVC.tabBarItem.title = localize(for: "TabbarShow")
        let showScheduleNavi = NavigationVC(rootViewController: showScheduleVC)

        let mapVC = MapVC()
        mapVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_map")
        mapVC.tabBarItem.title = localize(for: "TabbarMap")
        let mapNavi = NavigationVC(rootViewController: mapVC)

//        let suggestVC = SuggestVC()
//        suggestVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_suggest")
//        suggestVC.tabBarItem.title = localize(for: "TabbarSuggest")
//        let suggestNavi = NavigationVC(rootViewController: suggestVC)

//        let myPlanVC = MyPlanVC()
//        myPlanVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_myplan")
//        myPlanVC.tabBarItem.title = localize(for: "TabbarMyPlan")
//        let myPlanNavi = NavigationVC(rootViewController: myPlanVC)

//        let settingVC = SettingVC()
//        settingVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_setting")
//        settingVC.tabBarItem.title = localize(for: "TabbarSetting")
//        let settingNavi = NavigationVC(rootViewController: settingVC)

        let hotVC = HotVC()
        hotVC.tabBarItem.image = #imageLiteral(resourceName: "tab_bar_hot")
        hotVC.tabBarItem.title = localize(for: "TabbarHot")
        let hotNavi = NavigationVC(rootViewController: hotVC)

        let vcs = [attractionPageNavi, showScheduleNavi, mapNavi, hotNavi]
        setViewControllers(vcs, animated: false)
    }

}
