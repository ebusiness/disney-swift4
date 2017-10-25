//
//  AttractionSearchVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/25.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class AttractionSearchVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    private let searchBar: UISearchBar

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        searchBar = UISearchBar(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        hidesBottomBarWhenPushed = true

        addSubSearchBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = GlobalColor.viewBackgroundLightGray
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func addSubSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottom).isActive = true
        }
    }

}
