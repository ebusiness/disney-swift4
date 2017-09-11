//
//  AttractionVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/11.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class AttractionVC: UIViewController, Localizable {

    let localizeFileName = "attraction"

    init() {
        super.init(nibName: nil, bundle: nil)

        setupNavigation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupNavigation() {
        title = localize(for: "")
    }
}
