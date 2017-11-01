//
//  AttractionDetailVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/13.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class AttractionDetailVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    private let attraction: Attraction
    private var detail: AttractionDetailBase?

    let customizeNavigationBar: UINavigationBar
    let tableView: UITableView
    let imageCellIdentifier = "imageCellIdentifier"

    init(attraction: Attraction) {
        self.attraction = attraction

        customizeNavigationBar = UINavigationBar(frame: .zero)
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
        automaticallyAdjustsScrollViewInsets = false

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addSubTableView()

        requestAttractionDetail()
    }

    private func requestAttractionDetail() {
        let detailRequest = API.Attractions.detail(park: .land, id: attraction.str_id)

        detailRequest.request(AttractionDetailBase.self) { [weak self] (detail, error) in
            guard let strongSelf = self else { return }
            strongSelf.detail = detail
            strongSelf.tableView.reloadData()
        }
    }

    private func setupNavigationBar() {
        let statusBarBackground = UIView(frame: .zero)
        statusBarBackground.backgroundColor = UIColor.white
        view.addSubview(statusBarBackground)
        statusBarBackground.translatesAutoresizingMaskIntoConstraints = false
        statusBarBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        if #available(iOS 11.0, *) {
            statusBarBackground.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            statusBarBackground.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            statusBarBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            statusBarBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            statusBarBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            statusBarBackground.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }

        customizeNavigationBar.barStyle = .black
        customizeNavigationBar.isTranslucent = false
        customizeNavigationBar.barTintColor = UIColor.white
        customizeNavigationBar.tintColor = UIColor.black
        customizeNavigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let leftButtonString = NSAttributedString(string: titleOfPreviousViewController ?? localize(for: "back button defaul title"),
                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        leftButton.setImage(#imageLiteral(resourceName: "backButton"), for: .highlighted)
        leftButton.setAttributedTitle(leftButtonString,
                                      for: .normal)
        let backbuttonItem = UIBarButtonItem(customView: leftButton)
        let navigationItem = UINavigationItem(title: attraction.name)
        navigationItem.leftBarButtonItem = backbuttonItem
        customizeNavigationBar.items = [navigationItem]
        view.addSubview(customizeNavigationBar)
        customizeNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        customizeNavigationBar.topAnchor.constraint(equalTo: statusBarBackground.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            customizeNavigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            customizeNavigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            customizeNavigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            customizeNavigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
    }

    private func addSubTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = GlobalColor.viewBackgroundLightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AttractionDetailImageCell.self, forCellReuseIdentifier: imageCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: customizeNavigationBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
    }
}

extension AttractionDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if detail == nil {
            return 0
        } else {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCellIdentifier, for: indexPath) as! AttractionDetailImageCell
            cell.images = detail?.images
            return cell
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 195
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 12
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView()
        default:
            return nil
        }
    }
}
