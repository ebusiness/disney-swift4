//
//  CreatePlanMain.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/21.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class CreatePlanMain: UIViewController, Localizable {

    let localizeFileName = "CreatePlan"

    let emptyLabel: UILabel
    let navigationTitle: UILabel

    let collectionView: UICollectionView
    let cellIdentifier = "cellIdentifier"
    var dataList = [PlanListAttraction]()

    init() {
        navigationTitle = UILabel(frame: .zero)
        emptyLabel = UILabel(frame: .zero)

        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = GlobalColor.viewBackgroundLightGray

        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let nextButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nextButtonPressed(_:)))
        let settingButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(settingButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [nextButton, settingButton]

        navigationTitle.textColor = UIColor.white
        navigationTitle.font = UIFont.systemFont(ofSize: 18)
        navigationTitle.text = localize(for: "NavigationTitleNewPlan")
        navigationItem.titleView = navigationTitle
    }

    @objc
    private func nextButtonPressed(_ sender: UIBarButtonItem) {
        let next = CreatePlanCategory()
        navigationController?.pushViewController(next, animated: true)
    }

    @objc
    private func settingButtonPressed(_ sender: UIBarButtonItem) {

    }

    private func addSubCollectionView() {
        collectionView.register(CreatePlanMainCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
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

    func appendAttractions(_ attractions: [PlanListAttraction]) {
        let originalCount = dataList.count
        dataList += attractions
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
        return cell
    }
}
