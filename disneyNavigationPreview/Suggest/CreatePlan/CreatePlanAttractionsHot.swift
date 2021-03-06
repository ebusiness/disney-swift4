//
//  CreatePlanAttractionsHot.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/22.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class CreatePlanAttractionsHot: UIViewController {

    private let collectionView: UICollectionView
    private let cellIdentifier = "cellIdentifier"

    private var listData = [AttractionHot]()

    init() {

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 185)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)

        setupNavigationBar()
        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        requestAttractionList()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(_:)))
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.register(CreatePlanAttractionsHotCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        }
    }

    private func requestAttractionList() {
        let requester = API.Attractions.hot(park: .land)

        requester.request([AttractionHotResponseData].self) { [weak self] (data, _) in
            guard let strongSelf = self else { return }
            if let data = data {
                strongSelf.listData = data.flatMap({ AttractionHot(responseData:$0) })
                strongSelf.collectionView.reloadData()
            }
        }
    }

    @objc
    private func saveButtonPressed(_ sender: UIBarButtonItem) {
        let selectedAttractions = listData.filter({ $0.selected })

        var main: CreatePlanMain? = nil
        if let controllers = navigationController?.viewControllers {
            for controller in controllers where controller is CreatePlanMain {
                main = controller as? CreatePlanMain
                break
            }
        }
        if let existMain = main {
            if !selectedAttractions.isEmpty {
                existMain.appendAttractions(selectedAttractions)
            }
            navigationController?.popToViewController(existMain, animated: true)
        }

    }

}

extension CreatePlanAttractionsHot: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CreatePlanAttractionsHotCell
        cell.data = listData[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let selected = !listData[indexPath.item].selected
        listData[indexPath.item].selected = selected
        if let cell = collectionView.cellForItem(at: indexPath) as? CreatePlanAttractionsHotCell {
            if selected {
                cell.check()
            } else {
                cell.uncheck()
            }
        }
    }

}
