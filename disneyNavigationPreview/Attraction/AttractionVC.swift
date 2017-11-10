//
//  AttractionVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/11.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class AttractionVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    var spots = [Attraction]()

    typealias CallBackAction = ((Attraction) -> Void)
    private var _pushToDetailCallback: CallBackAction?

    private let collectionView: UICollectionView
    private let identifierFastpass = "identfierFastpass"
    private let identifierNoneFastpass = "identifierNoneFastpass"

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width,
                                 height: 185)
        layout.minimumLineSpacing = 12
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func addSubCollectionView() {
        let collectionBackground = UIView(frame: .zero)
        collectionBackground.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.backgroundView = collectionBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AttractionCellFastpass.self, forCellWithReuseIdentifier: identifierFastpass)
        collectionView.register(AttractionCellNoneFastpass.self, forCellWithReuseIdentifier: identifierNoneFastpass)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func pushToDetail(attraction: Attraction) {
        _pushToDetailCallback?(attraction)
    }

    @discardableResult
    func pushToDetailCallback(_ pushToDetailCallback: @escaping CallBackAction) -> AttractionVC {
        _pushToDetailCallback = pushToDetailCallback
        return self
    }

    func reloadAllSpots(_ spots: [Attraction]) {
        self.spots = spots
        collectionView.reloadData()
    }
}

extension AttractionVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let spot = spots[indexPath.row]
        let cell: AttractionCell
        if let fastpassAvailable = spot.realtime?.fastpassAvailable, fastpassAvailable {
            //swiftlint:disable:next force_cast
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierFastpass, for: indexPath)  as! AttractionCellFastpass
            cell.data = spot
        } else {
            //swiftlint:disable:next force_cast
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierNoneFastpass, for: indexPath) as! AttractionCellNoneFastpass
            cell.data = spot
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let attraction = spots[indexPath.item]
        pushToDetail(attraction: attraction)
    }

}
