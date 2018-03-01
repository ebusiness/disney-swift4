//
//  GreetingDetailVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/26.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class GreetingDetailVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    private let park: TokyoDisneyPark
    private let attractionId: String
    private let attractionName: String
    private var detail: AnalysedGreetingDetail? {
        didSet {
            collectionView.reloadData()
        }
    }

    private let customizeNavigationBar: UINavigationBar

    private let collectionView: UICollectionView
    private let imageCellIdentifier = "imageCellIdentifier"
    private let noteCellIdentifier = "noteCellIdentifier"
    private let otherCellIdentifier = "otherCellIdentifier"

    init(park: TokyoDisneyPark, attractionId: String, attractionName: String) {
        self.park = park
        self.attractionId = attractionId
        self.attractionName = attractionName

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
        let navigationItem = UINavigationItem(title: attractionName)
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
        collectionView.register(GreetingImageCell.self, forCellWithReuseIdentifier: imageCellIdentifier)
        collectionView.register(GreetingOtherCell.self, forCellWithReuseIdentifier: otherCellIdentifier)
        collectionView.register(GreetingNoteCell.self, forCellWithReuseIdentifier: noteCellIdentifier)
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
        let detailRequest = API.Attractions.detail(park: park, id: attractionId)

        detailRequest.request(GreetingDetail.self) { [weak self] (detail, _) in
            guard let strongSelf = self else { return }
            if let detail = detail {
                strongSelf.detail = AnalysedGreetingDetail(parent: detail)
            }
        }
    }

}

extension GreetingDetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

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
                return GreetingNoteCell.autoLayoutSize(detail: detail)
            } else {
                 return .zero
            }
        default:
            if let payload = detail?.payloads[indexPath.item - 2] {
                return GreetingOtherCell.autoLayoutSize(payload: payload)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! GreetingImageCell
            cell.detail = detail
            return cell
        } else if indexPath.item == 1 {
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noteCellIdentifier, for: indexPath) as! GreetingNoteCell
            cell.detail = detail
            return cell
        } else {
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherCellIdentifier, for: indexPath) as! GreetingOtherCell
            cell.payload = detail?.payloads[indexPath.item - 2]
            return cell
        }
    }
}

class AnalysedGreetingDetail: Localizable {

    let localizeFileName = "Attraction"

    let parent: GreetingDetail

    private var appropriateFor = [String]()
    private var barrierFree = [String]()
    private var photoTaking = [String]()
    private var participatingDisneyCharacters = [String]()

    var payloads = [Payload]()

    init(parent: GreetingDetail) {
        self.parent = parent
        analysis()
    }

    enum PayloadType {
        case participatingDisneyCharacter
        case barrierFree
        case appropriateFor
        case photoTaking
    }

    private func keys(for property: PayloadType) -> Set<String> {
        switch property {
        case .appropriateFor:
            return Set(["Appropriate for", "对象", "適合對象"])
        case .barrierFree:
            return Set(["Barrier Free", "游园无障碍", "無障礙資訊"])
        case .photoTaking:
            return Set(["Important Tag", "--1--"])
        case .participatingDisneyCharacter:
            return Set(["キャラクター", "Participating Disney Characters", "登场迪士尼明星", "登場的迪士尼明星"])
        }
    }

    private func analysis() {
        for tag in parent.summary_tags {
            if keys(for: .barrierFree).contains(tag.type) {
                barrierFree.append(contentsOf: Array(tag.tags))
            } else if keys(for: .participatingDisneyCharacter).contains(tag.type) {
                participatingDisneyCharacters.append(contentsOf: Array(tag.tags))
            } else if keys(for: .appropriateFor).contains(tag.type) {
                appropriateFor.append(contentsOf: Array(tag.tags))
            } else if keys(for: .photoTaking).contains(tag.type) {
                photoTaking.append(contentsOf: Array(tag.tags))
            }
        }
        if let payload = detail(for: .appropriateFor) {
            payloads.append(payload)
        }
        if let payload = detail(for: .barrierFree) {
            payloads.append(payload)
        }
        if let payload = detail(for: .photoTaking) {
            payloads.append(payload)
        }
        if let payload = detail(for: .participatingDisneyCharacter) {
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
        case .photoTaking:
            if !photoTaking.isEmpty {
                let key = localize(for: "Photo-taking services available for a fee")
                let value = localize(for: "Photo-taking services available for a fee content")
                return Payload(type: .photoTaking, title: key, content: value)
            } else {
                return nil
            }
        case .participatingDisneyCharacter:
            if !participatingDisneyCharacters.isEmpty {
                let key = localize(for: "Participating Disney Characters")
                let value = participatingDisneyCharacters.joined(separator: "\n")
                return Payload(type: .participatingDisneyCharacter, title: key, content: value)
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
