//
//  SettingVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/11.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

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
    }

    private func addSubTableView() {
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

}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SettingCell
        switch indexPath.row {
        case 0:
            cell.cellType = .alert
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        pushToAlertVC()
    }
    
}
