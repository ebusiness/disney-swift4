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
    let parkCell: UITableViewCell
    let dateCell: UITableViewCell
    let inTimeCell: UITableViewCell
    let outTimeCell: UITableViewCell

    let config = PlanConfiguration()

    init() {
        parkCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        dateCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        inTimeCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        outTimeCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true

        setupCells()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: localize(for: "NavigationNext"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(nextButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self, action: #selector(dismissButtonPressed(_:)))

        let titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = navigationController?.navigationBar.tintColor
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = localize(for: "NavigationTitleBaseInfo")
        navigationItem.titleView = titleLabel
    }

    @objc
    private func nextButtonPressed(_ sender: UIBarButtonItem) {
        let next = CreatePlanMain()
        navigationController?.pushViewController(next, animated: true)
    }

    @objc
    private func dismissButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }

    private func setupCells() {
        parkCell.textLabel?.text = localize(for: "BaseInfoPark")
        parkCell.detailTextLabel?.text = config.park.localize()
        parkCell.imageView?.image = #imageLiteral(resourceName: "setting_park")

        dateCell.textLabel?.text = localize(for: "BaseInfoDate")
        dateCell.detailTextLabel?.text = config.date.systemFormat(dateStyle: .medium, timeStyle: .none)
        dateCell.imageView?.image = #imageLiteral(resourceName: "setting_date")

        inTimeCell.textLabel?.text = localize(for: "BaseInfoInTime")
        inTimeCell.detailTextLabel?.text = String(format: "%02d:%02d", config.startTime.hour!, config.startTime.minute!)
        inTimeCell.imageView?.image = #imageLiteral(resourceName: "setting_starttime")

        outTimeCell.textLabel?.text = localize(for: "BaseInfoOutTime")
        outTimeCell.detailTextLabel?.text = localize(for: "BaseInfoOutTimeNone")
        outTimeCell.imageView?.image = #imageLiteral(resourceName: "setting_endtime")
    }

    private func addSubTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = GlobalColor.viewBackgroundLightGray
        tableView.rowHeight = 44
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
