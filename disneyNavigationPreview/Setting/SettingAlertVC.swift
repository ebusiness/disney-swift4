//
//  SettingAlertVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/29.
//  Copyright © 2018 ebuser. All rights reserved.
//

import CoreData
import UIKit

class SettingAlertVC: UIViewController, Localizable {

    let localizeFileName = "Setting"

    private let customizeNavigationBar: UINavigationBar

    let tableView: UITableView
    let identifier = "identifier"
    var fetchedResultsController: NSFetchedResultsController<Alarm>!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        tableView = UITableView(frame: .zero, style: .plain)
        customizeNavigationBar = UINavigationBar(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        hidesBottomBarWhenPushed = true
        setupNavigationBar()
        addSubTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func addSubTableView() {
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        tableView.backgroundColor = GlobalColor.viewBackgroundLightGray
        tableView.register(SettingAlertCell.self, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 68
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: customizeNavigationBar.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }

    private func requestData() {
        let request = NSFetchRequest<Alarm>(entityName: "Alarm")
        let timeSort = NSSortDescriptor(key: "time", ascending: true)
        let now = Date()
        let predict = NSPredicate(format: "time > %@", argumentArray: [now])
        request.sortDescriptors = [timeSort]
        request.predicate = predict

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: DB.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch data failed")
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
        leftButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        let backbuttonItem = UIBarButtonItem(customView: leftButton)
        let navigationItem = UINavigationItem(title: localize(for: "Alert"))
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

    @objc
    private func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

extension SettingAlertVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? SettingAlertCell else {
            fatalError("Wrong cell type dequeued")
        }
        let object = fetchedResultsController.object(at: indexPath)
        cell.data = object
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
}

extension SettingAlertVC: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
