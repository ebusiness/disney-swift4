//
//  CreatePlanMain.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/21.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import RxSwift
import UIKit

final class CreatePlanMain: UIViewController, Localizable {

    let localizeFileName = "CreatePlan"

    let emptyLabel: UILabel
    let navigationTitle: UILabel

    let toolbarNormal: UIToolbar
    var selectButton: UIBarButtonItem?
    let toolbarSelect: UIToolbar
    var cancelButton: UIBarButtonItem?
    var trashButton: UIBarButtonItem?

    let collectionView: UICollectionView
    let cellIdentifier = "cellIdentifier"
    var dataList = [PlanListAttraction]() {
        didSet {
            dataEmptyWatcher.value = dataList.isEmpty
        }
    }

    let disposeBag = DisposeBag()
    // MARK: - Watchers
    let dataEmptyWatcher: Variable<Bool>
    let selectEmptyWatcher: Variable<Bool>
    // MARK: -

    var saveButtonItem: UIBarButtonItem?
    var selecting = false {
        didSet {
            if selecting {
                toolbarNormal.isHidden = true
                toolbarSelect.isHidden = false
                navigationItem.setHidesBackButton(true, animated: true)
                navigationItem.rightBarButtonItem = nil
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                collectionView
                    .visibleCells
                    .forEach({ cell in
                        //swiftlint:disable:next force_cast
                        let cell = cell as! CreatePlanMainCell
                        cell.setCheckboxHidden(false)
                    })
            } else {
                toolbarNormal.isHidden = false
                toolbarSelect.isHidden = true
                navigationItem.setHidesBackButton(false, animated: true)
                navigationItem.rightBarButtonItem = saveButtonItem
                navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                collectionView
                    .visibleCells
                    .forEach({ cell in
                        //swiftlint:disable:next force_cast
                        let cell = cell as! CreatePlanMainCell
                        cell.setCheckboxHidden(true)
                    })
            }
        }
    }

    init() {
        navigationTitle = UILabel(frame: .zero)
        emptyLabel = UILabel(frame: .zero)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 24, height: 60)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        toolbarNormal = UIToolbar()
        toolbarSelect = UIToolbar()

        dataEmptyWatcher = Variable(dataList.isEmpty)
        selectEmptyWatcher = Variable(dataList.filter({ $0.selected }).isEmpty)
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = GlobalColor.viewBackgroundLightGray

        addSubCollectionView()
        setupWatchers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupToolbarNormal()
        setupToolbarSelect()
    }

    private func setupNavigationBar() {

        saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(_:)))
        navigationItem.rightBarButtonItem = saveButtonItem

        navigationTitle.textColor = navigationController?.navigationBar.tintColor
        navigationTitle.font = UIFont.systemFont(ofSize: 18)
        navigationTitle.text = localize(for: "NavigationTitleNewPlan")
        navigationItem.titleView = navigationTitle
    }

    @objc
    private func addButtonPressed(_ sender: UIBarButtonItem) {
        let add = CreatePlanCategory()
        navigationController?.pushViewController(add, animated: true)
    }

    @objc
    private func settingButtonPressed(_ sender: UIBarButtonItem) {

    }

    @objc
    private func saveButtonPressed(_ sender: UIBarButtonItem) {

    }

    @objc
    private func selectOrCancelButtonPressed(_ sender: UIBarButtonItem) {
        selecting = !selecting
        if sender == cancelButton {
            for idx in 0..<dataList.count {
                dataList[idx].selected = false
            }
        }
    }

    @objc
    private func trashButtonPressed(_ sender: UIBarButtonItem) {
        var removeIndexPaths = [IndexPath]()
        dataList.enumerated().forEach { (tuple) in
            if tuple.element.selected {
                removeIndexPaths.append(IndexPath(item: tuple.offset, section: 0))
            }
        }
        dataList = dataList.filter { !$0.selected }
        collectionView.deleteItems(at:removeIndexPaths)
        selectEmptyWatcher.value = true
        if dataList.isEmpty {
            selectOrCancelButtonPressed(cancelButton!)
        }
    }

    private func addSubCollectionView() {
        collectionView.register(CreatePlanMainCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.isPrefetchingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44).isActive = true
        } else {
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: -44).isActive = true
        }

        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = GlobalColor.noDataText
        emptyLabel.font = UIFont.systemFont(ofSize: 15)
        emptyLabel.text = localize(for: "MyPlanNoData")
        collectionView.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        emptyLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 120).isActive = true
    }

    private func setupToolbarNormal() {
        toolbarNormal.barStyle = .black
        toolbarNormal.barTintColor = UIColor.white
        toolbarNormal.tintColor = GlobalColor.primaryRed
        view.addSubview(toolbarNormal)
        toolbarNormal.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            toolbarNormal.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            toolbarNormal.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            toolbarNormal.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            toolbarNormal.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            toolbarNormal.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            toolbarNormal.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }

        selectButton = UIBarButtonItem(title: localize(for: "toolbar_select"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(selectOrCancelButtonPressed(_:)))

        let settingButton = UIBarButtonItem(title: localize(for: "toolbar_setting"),
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        let suggestButton = UIBarButtonItem(title: localize(for: "toolbar_suggest"),
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        let addButton = UIBarButtonItem(title: localize(for: "toolbar_add"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(addButtonPressed(_:)))
        toolbarNormal.items = [selectButton!,
                               UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                               settingButton,
                               UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                               suggestButton,
                               UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                               addButton]
    }

    private func setupToolbarSelect() {
        toolbarSelect.barStyle = .black
        toolbarSelect.barTintColor = UIColor.white
        toolbarSelect.tintColor = GlobalColor.primaryRed
        toolbarSelect.isHidden = true
        view.addSubview(toolbarSelect)
        toolbarSelect.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            toolbarSelect.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            toolbarSelect.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            toolbarSelect.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            toolbarSelect.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            toolbarSelect.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            toolbarSelect.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                       target: self,
                                       action: #selector(selectOrCancelButtonPressed(_:)))
        cancelButton!.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)],
                                             for: .normal)
        trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                      target: self,
                                      action: #selector(trashButtonPressed(_:)))
        toolbarSelect.items = [cancelButton!,
                               UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                               trashButton!]
    }

    private func setupWatchers() {
        dataEmptyWatcher
            .asObservable()
            .subscribe (onNext: { [weak self] isEmpty in
                guard let strongSelf = self else { return }
                strongSelf.setSelectAndSaveEnabled(!isEmpty)
            })
            .disposed(by: disposeBag)
        selectEmptyWatcher
            .asObservable()
            .subscribe(onNext: { [weak self] isEmpty in
                guard let strongSelf = self else { return }
                strongSelf.setTrashEnabled(!isEmpty)
            })
            .disposed(by: disposeBag)
    }

    private func setSelectAndSaveEnabled(_ enable: Bool) {
        saveButtonItem?.isEnabled = enable
        selectButton?.isEnabled = enable
    }

    private func setTrashEnabled(_ enable: Bool) {
        trashButton?.isEnabled = enable
    }

    func appendAttractions(_ attractions: [PlanListAttractionCompatible]) {
        let originalCount = dataList.count
        dataList += attractions.map { PlanListAttraction($0) }
        var indexPaths = [IndexPath]()
        for i in 0..<attractions.count {
            indexPaths.append(IndexPath(item: originalCount + i, section: 0))
        }
        collectionView.insertItems(at: indexPaths)
    }

}

extension CreatePlanMain: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = dataList.count
        if number == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        return number
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CreatePlanMainCell
        cell.data = dataList[indexPath.item]
        if selecting {
            cell.setCheckboxHidden(false)
        } else {
            cell.setCheckboxHidden(true)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selecting {
            collectionView.deselectItem(at: indexPath, animated: false)
            let selected = !dataList[indexPath.item].selected
            dataList[indexPath.item].selected = selected
            if let cell = collectionView.cellForItem(at: indexPath) as? CreatePlanMainCell {
                if selected {
                    cell.check()
                } else {
                    cell.uncheck()
                }
            }
            selectEmptyWatcher.value = dataList.filter({ $0.selected }).isEmpty
        } else {
            return
        }
    }
}
