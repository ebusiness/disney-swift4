//
//  CreatePlanTimeAndPark.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/21.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class CreatePlanTimeAndPark: UIViewController, Localizable {

    let localizeFileName = "CreatePlan"

    let tableView: UITableView
    let parkCell = CreatePlanTimeAndParkParkCell()
    let dateCell = CreatePlanTimeAndParkDateCell()
    let inTimeCell = CreatePlanTimeAndParkInTimeCell()
    let outTimeCell = CreatePlanTimeAndParkOutTimeCell()

    init() {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true

        addSubTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(nextButtonPressed(_:)))

        let titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = localize(for: "NavigationTitleBaseInfo")
        navigationItem.titleView = titleLabel

    }

    @objc
    private func nextButtonPressed(_ sender: UIBarButtonItem) {

        let next = CreatePlanMain()
        navigationController?.pushViewController(next, animated: true)
    }

    private func addSubTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = GlobalColor.viewBackgroundLightGray
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        }

    }

}

extension CreatePlanTimeAndPark: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return parkCell
        case 1:
            return dateCell
        case 2:
            return inTimeCell
        case 3:
            return outTimeCell
        default:
            fatalError()
        }
    }

}
