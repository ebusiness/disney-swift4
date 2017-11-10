//
//  ShowDetailVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/1.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class ShowDetailVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    private let park: TokyoDisneyPark
    private let attraction: Attraction
    private var detail: AnalysedShowDetail? {
        didSet {
            collectionView.reloadData()
        }
    }

    private let customizeNavigationBar: UINavigationBar

    private let collectionView: UICollectionView
    private let imageCellIdentifier = "imageCellIdentifier"
    private let noteCellIdentifier = "noteCellIdentifier"
    private let otherCellIdentifier = "otherCellIdentifier"

    init(park: TokyoDisneyPark, attraction: Attraction) {
        self.park = park
        self.attraction = attraction

        customizeNavigationBar = UINavigationBar(frame: .zero)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true

        setupNavigationBar()
        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requestAttractionDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        let navigationItem = UINavigationItem(title: attraction.name)
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

    private func addSubCollectionView() {
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShowImageCell.self, forCellWithReuseIdentifier: imageCellIdentifier)
        collectionView.register(ShowOtherCell.self, forCellWithReuseIdentifier: otherCellIdentifier)
        collectionView.register(ShowNoteCell.self, forCellWithReuseIdentifier: noteCellIdentifier)
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: customizeNavigationBar.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        }
    }

    @objc
    private func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    private func requestAttractionDetail() {
        let detailRequest = API.Attractions.detail(park: park, id: attraction.str_id)

        detailRequest.request(ShowDetail.self) { [weak self] (detail, error) in
            guard let strongSelf = self else { return }
            if let detail = detail {
                strongSelf.detail = AnalysedShowDetail(parent: detail)
            }
        }
    }

}

extension ShowDetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            let screenWidth = UIScreen.main.bounds.width
            let ratio = CGFloat(414) / CGFloat(192)
            let height = screenWidth / ratio
            return CGSize(width: screenWidth, height: height)
        case 1:
            if let detail = detail {
                return ShowNoteCell.autoLayoutSize(detail: detail)
            } else {
                return .zero
            }
        default:
            if let payload = detail?.payloads[indexPath.item - 2] {
                return ShowOtherCell.autoLayoutSize(payload: payload)
            } else {
                return .zero
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let detail = detail {
            return detail.payloads.count + 2
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ShowImageCell
            cell.detail = detail
            return cell
        } else if indexPath.item == 1 {
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noteCellIdentifier, for: indexPath) as! ShowNoteCell
            cell.detail = detail
            return cell
        } else {
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherCellIdentifier, for: indexPath) as! ShowOtherCell
            cell.payload = detail?.payloads[indexPath.item - 2]
            return cell
        }
    }
}

class AnalysedShowDetail: Localizable {

    let localizeFileName = "Attraction"

    let parent: ShowDetail

    private var appropriateFor = [String]()
    private var barrierFree = [String]()
    private var showType = [String]()
    private var reservationsRequired = [String]()
    private var seatsAvailableByLottery = [String]()

    var payloads = [Payload]()

    init(parent: ShowDetail) {
        self.parent = parent
        analysis()
    }

    enum PayloadType {
        case showType
        case barrierFree
        case appropriateFor
        case reservationsRequired
        case seatsAvailableByLottery
    }

    private func keys(for property: PayloadType) -> Set<String> {
        switch property {
        case .appropriateFor:
            return Set(["Appropriate for", "对象", "適合對象"])
        case .barrierFree:
            return Set(["Barrier Free", "游园无障碍", "無障礙資訊"])
        case .reservationsRequired:
            return Set(["Reservations required", "予約が必要", "需要预订座位", "必須預約"])
        case .showType:
            return Set(["Show Type", "娱乐表演分类", "娛樂表演型態"])
        case .seatsAvailableByLottery:
            return Set(["Seats available by lottery", "座席抽選あり", "需要抽签", "必須參加席位抽選"])
        }
    }

    private func analysis() {
        for tag in parent.summary_tags {
            if keys(for: .barrierFree).contains(tag.type) {
                barrierFree.append(contentsOf: tag.tags)
            } else if keys(for: .appropriateFor).contains(tag.type) {
                appropriateFor.append(contentsOf: tag.tags)
            } else if keys(for: .showType).contains(tag.type) {
                showType.append(contentsOf: tag.tags)
            } else {
                if let tag0 = tag.tags.first {
                    if keys(for: .reservationsRequired).contains(tag0) {
                        reservationsRequired.append(contentsOf: tag.tags)
                    } else if keys(for: .seatsAvailableByLottery).contains(tag0) {
                        seatsAvailableByLottery.append(contentsOf: tag.tags)
                    }
                }
            }
        }
        if let payload = detail(for: .appropriateFor) {
            payloads.append(payload)
        }
        if let payload = detail(for: .barrierFree) {
            payloads.append(payload)
        }
        if let payload = detail(for: .showType) {
            payloads.append(payload)
        }
        if let payload = detail(for: .reservationsRequired) {
            payloads.append(payload)
        }
        if let payload = detail(for: .seatsAvailableByLottery) {
            payloads.append(payload)
        }
    }

    func detail(for property: PayloadType) -> Payload? {
        switch property {
        case .appropriateFor:
            if !appropriateFor.isEmpty {
                let key = localize(for: "Appropriate for")
                let value = appropriateFor.joined(separator: "\n")
                return Payload(type: .appropriateFor, title: key, content: value)
            } else {
                return nil
            }
        case .barrierFree:
            if !barrierFree.isEmpty {
                let key = localize(for: "Barrier Free")
                let value = barrierFree.joined(separator: "\n")
                return Payload(type: .barrierFree, title: key, content: value)
            } else {
                return nil
            }
        case .reservationsRequired:
            if !reservationsRequired.isEmpty {
                let key = localize(for: "Reservations required")
                let value = localize(for: "Reservations required content")
                return Payload(type: .reservationsRequired, title: key, content: value)
            } else {
                return nil
            }
        case .showType:
            if !showType.isEmpty {
                let key = localize(for: "Show type")
                let value = showType.joined(separator: "\n")
                return Payload(type: .showType, title: key, content: value)
            } else {
                return nil
            }
        case .seatsAvailableByLottery:
            if !seatsAvailableByLottery.isEmpty {
                let key = localize(for: "Seats available by lottery")
                let value = localize(for: "Seats available by lottery content")
                return Payload(type: .seatsAvailableByLottery, title: key, content: value)
            } else {
                return nil
            }
        }
    }

    struct Payload {
        let type: PayloadType
        let title: String
        let content: String
    }
}
