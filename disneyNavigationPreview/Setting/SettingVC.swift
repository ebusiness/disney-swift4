//
//  SettingVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/11.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class SettingVC: UIViewController, Localizable {

    let localizeFileName = "Setting"

    let tableView: UITableView
    let cellIdentifier = "cellIdentifier"

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        tableView = UITableView(frame: .zero, style: .grouped)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        addSubTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupNavigation() {
        navigationItem.title = localize(for: "navigation title")
    }

    private func addSubTableView() {
        tableView.backgroundColor = GlobalColor.viewBackgroundLightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: cellIdentifier)
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }

    private func pushToAlertVC() {
        let alertVC = SettingAlertVC()
        navigationController?.pushViewController(alertVC, animated: true)
    }

    private func pushToAlertAdvanceVC() {
        let next = SettingAlertAdvanceVC()
        next
            .checked
            .asObservable()
            .subscribe { [weak self] _ in
                self?.tableView.reloadData()
            }
            .disposed(by: next.disposeBag)
        navigationController?.pushViewController(next, animated: true)
    }

}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SettingCell
        if let mcell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SettingCell {
            cell = mcell
        } else {
            cell = SettingCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.cellType = .alert
        case (1, 0):
            cell.cellType = .alertAdvance
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            pushToAlertVC()
        case (1, 0):
            pushToAlertAdvanceVC()
        default:
            break
        }
    }

}
