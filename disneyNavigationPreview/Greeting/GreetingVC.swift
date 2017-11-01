//
//  GreetingVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/19.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class GreetingVC: UIViewController {

    var spots = [Attraction]()

    private let collectionView: UICollectionView
    private let cellIdentifier = "cellIdentifier"

    typealias CallBackAction = ((Attraction) -> Void)
    private var _pushToDetailCallback: CallBackAction?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width,
                                 height: 185)
        layout.minimumLineSpacing = 12
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubCollectionView()
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GreetingCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    func reloadAllSpots(_ spots: [Attraction]) {
        self.spots = spots
        collectionView.reloadData()
    }

    private func pushToDetail(attraction: Attraction) {
        _pushToDetailCallback?(attraction)
    }

    @discardableResult
    func pushToDetailCallback(_ pushToDetailCallback: @escaping CallBackAction) -> GreetingVC {
        _pushToDetailCallback = pushToDetailCallback
        return self
    }

}

extension GreetingVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let spot = spots[indexPath.item]

        var cell: GreetingCell
        //swiftlint:disable:next force_cast
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GreetingCell
        cell.data = spot
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let spot = spots[indexPath.item]
        pushToDetail(attraction: spot)
    }
}
