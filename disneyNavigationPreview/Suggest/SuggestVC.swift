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
    var suggestedPlans = [SuggestPlan]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = GlobalColor.viewBackgroundLightGray
        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestSuggestionList()
    }

    private func addSubCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
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
        let suggestionListRequest = API.Attractions.list

        suggestionListRequest.request([SuggestPlan].self) { [weak self] (data, error) in
            guard let strongSelf = self else { return }
            if let data = data {
                strongSelf.suggestedPlans = data
                strongSelf.collectionView.reloadData()
            }
        }
    }

}

extension SuggestVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
