//
//  ShowScheduleVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/19.
//  Copyright © 2018 ebuser. All rights reserved.
//

import UIKit
import RxSwift

class ShowScheduleVC: UIViewController {

    let disposeBag = DisposeBag()

    private var timeline: AnalysedTimeline? {
        didSet {
            collectionView.reloadData()
        }
    }

    private let collectionView: UICollectionView
    private let blackIdentifier = "blackIdentifier"
    private let whiteIdentifier = "whiteIdentifier"

    var park = TokyoDisneyPark.land {
        didSet {
            if oldValue != park {
                updateNavigationTitle()
                requestTimeline()
            }
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = TimeLineLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GlobalColor.viewBackgroundLightGray
        updateNavigationTitle()

        requestTimeline()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func requestTimeline() {
        let now = Date()
        let detailRequest = API.Show.list(park: park, date: now.dateStringInTokyo)

        detailRequest.request([ShowTimeline].self) { [weak self](timelines, _) in
            guard let strongSelf = self else { return }
            if let timelines = timelines {
                strongSelf.timeline = AnalysedTimeline(parent: timelines)
            }
        }
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        collectionView.register(TimeLineBlackCell.self, forSupplementaryViewOfKind: TimeLineLayout.supplementaryKindBlack, withReuseIdentifier: blackIdentifier)
        collectionView.register(TimeLineWhiteCell.self, forCellWithReuseIdentifier: whiteIdentifier)
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

    private func updateNavigationTitle() {
        if navigationItem.titleView == nil {
            let button = RightImageButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "ic_repeat_black_24px"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "ic_repeat_black_24px"), for: .highlighted)
            button.setTitle(park.localize(), for: .normal)
            button.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
            navigationItem.titleView = button
        } else {
            guard let button = navigationItem.titleView as? UIButton else { return }
            button.setTitle(park.localize(), for: .normal)
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

extension ShowScheduleVC: UICollectionViewDelegateTimeLineLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeline?.events[safe: section]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: whiteIdentifier, for: indexPath) as! TimeLineWhiteCell
        let event = timeline?.events[safe: indexPath.section]?[safe: indexPath.item]
        cell.event = event
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: TimeLineLayout.supplementaryKindBlack, withReuseIdentifier: blackIdentifier, for: indexPath) as! TimeLineBlackCell
        cell.timeLabel.text = "\(indexPath.section + 8):00"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, startTimeAt indexPath: IndexPath) -> CGFloat {
        return timeline?.events[safe: indexPath.section]?[safe: indexPath.item]?.start ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, durationAt indexPath: IndexPath) -> CGFloat {
        return timeline?.events[safe: indexPath.section]?[safe: indexPath.item]?.duration ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if let event = timeline?.events[safe: indexPath.section]?[safe: indexPath.item] {
            let next = ShowDetailVC(park: park, attractionId: event.id, attractionName: event.name)
            navigationController?.pushViewController(next, animated: true)
        }
    }

}
