//
//  CreatePlanMain.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/21.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class CreatePlanMain: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = GlobalColor.viewBackgroundLightGray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let nextButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nextButtonPressed(_:)))
        let settingButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(settingButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [nextButton, settingButton]
    }

    @objc
    private func nextButtonPressed(_ sender: UIBarButtonItem) {
        let next = CreatePlanCategory()
        navigationController?.pushViewController(next, animated: true)
    }

    @objc
    private func settingButtonPressed(_ sender: UIBarButtonItem) {

    }

}
