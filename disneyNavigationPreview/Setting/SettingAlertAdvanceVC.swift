//
//  SettingAlertAdvanceVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/02/08.
//  Copyright © 2018 ebuser. All rights reserved.
//

import RxSwift
import UIKit

class SettingAlertAdvanceVC: UIViewController, Localizable {

    let localizeFileName = "Setting"
    let tableView: UITableView
    let identifier = "identifier"
    let disposeBag = DisposeBag()

    let checked = Variable<AlertAdvanceTime>(UserDefaultUtils.getAlertAdvanceTime())

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        addSubTableView()
        registerActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func addSubTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func registerActions() {
        checked
            .asObservable()
            .subscribe { event in
                guard let value = event.element else { return }
                UserDefaultUtils.setAlertAdvanceTime(value)
            }
            .disposed(by: disposeBag)
    }

}

extension SettingAlertAdvanceVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.tintColor = UIColor.green
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = localize(for: "Alert Advance \(AlertAdvanceTime.just.rawValue)")
            if checked.value == .just {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case 1:
            cell.textLabel?.text = localize(for: "Alert Advance \(AlertAdvanceTime.before5.rawValue)")
            if checked.value == .before5 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case 2:
            cell.textLabel?.text = localize(for: "Alert Advance \(AlertAdvanceTime.before10.rawValue)")
            if checked.value == .before10 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case 3:
            cell.textLabel?.text = localize(for: "Alert Advance \(AlertAdvanceTime.before15.rawValue)")
            if checked.value == .before15 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case 4:
            cell.textLabel?.text = localize(for: "Alert Advance \(AlertAdvanceTime.before30.rawValue)")
            if checked.value == .before30 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            checked.value = .just
        case 1:
            checked.value = .before5
        case 2:
            checked.value = .before10
        case 3:
            checked.value = .before15
        case 4:
            checked.value = .before30
        default:
            break
        }
        tableView.reloadData()
    }
}
