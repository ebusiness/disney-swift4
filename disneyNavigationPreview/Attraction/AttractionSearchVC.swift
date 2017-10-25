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

    private let searchContainer: UIView

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        searchContainer = UIView(frame: .zero)
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
        searchContainer.backgroundColor = GlobalColor.viewBackgroundLightGray
        view.addSubview(searchContainer)
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if #available(iOS 11.0, *) {
            searchContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            searchContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            searchContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            searchContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            searchContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            searchContainer.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }

        addSubSearchBackground()

        let seperator = UIView(frame: .zero)
        seperator.backgroundColor = UIColor.lightGray
        searchContainer.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leftAnchor.constraint(equalTo: searchContainer.leftAnchor).isActive = true
        seperator.rightAnchor.constraint(equalTo: searchContainer.rightAnchor).isActive = true
        seperator.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }

    private func addSubSearchBackground() {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(white: 0.15, alpha: 1), for: .normal)
        button.setTitle(localize(for: "search bar cancel"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        let bg = UIImageView(frame: .zero)
        bg.image = #imageLiteral(resourceName: "searchBackground")

        searchContainer.addSubview(button)
        searchContainer.addSubview(bg)
        button.translatesAutoresizingMaskIntoConstraints = false
        bg.translatesAutoresizingMaskIntoConstraints = false

        bg.leftAnchor.constraint(equalTo: searchContainer.leftAnchor, constant: 6).isActive = true
        bg.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: button.leftAnchor, constant: -6).isActive = true
        button.rightAnchor.constraint(equalTo: searchContainer.rightAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc
    private func cancelButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
