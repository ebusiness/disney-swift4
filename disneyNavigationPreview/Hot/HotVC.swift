//
//  HotVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/19.
//  Copyright © 2018 ebuser. All rights reserved.
//

import RxSwift
import UIKit

class HotVC: UIViewController, Localizable {

    let localizeFileName = "Hot"

    private let collectionView: UICollectionView
    private let cellIdentifier = "cellIdentifier"

    private let disposeBag = DisposeBag()

    private var listData = [AttractionHot]()

    var park = TokyoDisneyPark.land {
        didSet {
            if oldValue != park {
                updateNavigationLeftButton()
                requestAttractionList()
            }
        }
    }

    init() {

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 185)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)

        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateNavigationLeftButton()
        updateNavigationTitle()
        requestAttractionList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.register(HotCell.self, forCellWithReuseIdentifier: cellIdentifier)
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
        let requester = API.Attractions.hot(park: park)

        requester.request([AttractionHotResponseData].self) { [weak self] (data, _) in
            guard let strongSelf = self else { return }
            if let data = data {
                strongSelf.listData = data.flatMap({ AttractionHot(responseData:$0) })
                strongSelf.collectionView.reloadData()
            }
        }
    }

    private func updateNavigationTitle() {
        title = localize(for: "title")
    }

    private func updateNavigationLeftButton() {

        if navigationItem.leftBarButtonItem == nil {
            let leftItem = UIBarButtonItem(title: park.short,
                                           style: .plain,
                                           target: self,
                                           action: #selector(titleButtonPressed(_:)))
            navigationItem.leftBarButtonItem = leftItem
        } else {
            guard let leftItem = navigationItem.leftBarButtonItem else { return }
            leftItem.title = park.short
        }

    }

    @objc
    private func titleButtonPressed(_ sender: UIButton) {
        let parkpicker = BaseInfoParkPickVC(park: park)
        parkpicker
            .currentPark
            .asObservable()
            .subscribe(onNext: { [weak self] park in
                self?.park = park
            })
            .disposed(by: disposeBag)
        guard let tabVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else { return }
        tabVC.present(parkpicker, animated: false)
    }

}

extension HotVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HotCell
        cell.data = listData[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let spot = listData[indexPath.item]
        switch spot.category {
        case .attraction:
            let next = AttractionDetailVC(park: park, attractionId: spot.str_id, attractionName: spot.name)
            navigationController?.pushViewController(next, animated: true)
        case .greeting:
            let next = GreetingDetailVC(park: park, attractionId: spot.str_id, attractionName: spot.name)
            navigationController?.pushViewController(next, animated: true)
        case .show:
            let next = ShowDetailVC(park: park, attractionId: spot.str_id, attractionName: spot.name)
            navigationController?.pushViewController(next, animated: true)
        }
    }

}
