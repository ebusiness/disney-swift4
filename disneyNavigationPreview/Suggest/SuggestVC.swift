//
//  SuggestVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/11.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class SuggestVC: UIViewController {

    let collectionView: UICollectionView
    let cellIdentifier = "cellIdentifier"
    var suggestedPlans = [SuggestPlan]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        let layout = UICollectionViewFlowLayout()
        let itemSize = CGSize(width: UIScreen.main.bounds.width, height: 265)
        layout.minimumLineSpacing = 12
        layout.itemSize = itemSize
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = GlobalColor.viewBackgroundLightGray
        setupNavigationBar()
        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestSuggestionList()
    }

    private func setupNavigationBar() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "nav_bar_logo_white"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
    }

    private func addSubCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.register(SuggestCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        } else {
            // Fallback on earlier versions
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        }

    }

    private func requestSuggestionList() {
        let suggestionListRequest = API.Suggestion.list(park: .land)

        suggestionListRequest.request([SuggestPlan].self) { [weak self] (data, error) in
            guard let strongSelf = self else { return }
            if let data = data {
                strongSelf.suggestedPlans = data
                strongSelf.collectionView.reloadData()
            }
        }
    }

    @objc
    private func addButtonPressed(_ sender: UIBarButtonItem) {
        let createPlanVC = CreatePlanTimeAndPark()
        let navigationVC = WhiteNavigationVC(rootViewController: createPlanVC)
        present(navigationVC, animated: true)
    }

}

extension SuggestVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedPlans.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SuggestCell
        cell.planData = suggestedPlans[indexPath.item]
        return cell
    }

}
