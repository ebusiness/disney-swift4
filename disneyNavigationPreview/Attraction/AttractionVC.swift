//
//  AttractionVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/11.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class AttractionVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    var spots = [Attraction]()

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

        setupNavigation()
        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requestAttractionList()
    }

    private func setupNavigation() {
        title = localize(for: "attraction title")

        let rightButton = UIButton(type: .custom)
        let rightButtonString = NSAttributedString(string: TokyoDisneyPark.land.localize(),
                                                   attributes: [NSAttributedStringKey.foregroundColor: GlobalColor.primaryBlack,
                                                                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)])
        rightButton.setAttributedTitle(rightButtonString, for: .normal)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 5.5, left: 10, bottom: 5.5, right: 10)
        rightButton.backgroundColor = UIColor.white
        rightButton.layer.cornerRadius = 11.5
        rightButton.layer.masksToBounds = true
        let rightButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightButtonItem

        let leftButton = UIButton(type: .custom)
        let leftButtonString = NSAttributedString(string: " " + localize(for: "attraction filter"),
                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                               NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        leftButton.setImage(#imageLiteral(resourceName: "attraction_filter"), for: .normal)
        leftButton.setImage(#imageLiteral(resourceName: "attraction_filter"), for: .highlighted)
        leftButton.setAttributedTitle(leftButtonString, for: .normal)
        let leftButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftButtonItem
    }

    private func requestAttractionList() {
        let attractionListRequest = API.Attractions.list

        attractionListRequest.request([Attraction].self) { [weak self] (attractions, _) in
            guard let strongSelf = self else { return }
            if let attractions = attractions {
                strongSelf.spots = attractions
            }
        }
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AttractionCellFastpass.self, forCellWithReuseIdentifier: identifierFastpass)
        collectionView.register(AttractionCellNoneFastpass.self, forCellWithReuseIdentifier: identifierNoneFastpass)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
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

}
