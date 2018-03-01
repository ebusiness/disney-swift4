//
//  AttractionDetailVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/06.
//  Copyright © 2017 ebuser. All rights reserved.
//

import UIKit

class AttractionDetailVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    private var detail: AnalysedAttractionDetail?
    private var waitTime: AnalysedWaitTime?

    private let park: TokyoDisneyPark
    private let attractionId: String
    private let attractionName: String

    private let customizeNavigationBar: UINavigationBar

    private let collectionView: UICollectionView
    private let imageCellIdentifier = "imageCellIdentifier"
    private let chartCellIdentifier = "chartCellIdentifier"
    private let noteCellIdentifier = "noteCellIdentifier"
    private let otherCellIdentifier = "otherCellIdentifier"

    private var dataFetched = DataFetched()

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
        requestWaitTime()
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

        addNavButtons()
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
        collectionView.register(AttractionImageCell.self, forCellWithReuseIdentifier: imageCellIdentifier)
        collectionView.register(AttractionOtherCell.self, forCellWithReuseIdentifier: otherCellIdentifier)
        collectionView.register(AttractionNoteCell.self, forCellWithReuseIdentifier: noteCellIdentifier)
        collectionView.register(AttractionChartCell.self, forCellWithReuseIdentifier: chartCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
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

    @objc
    private func rightButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let collectAction = UIAlertAction(title: localize(for: "Save favorite"),
                                          style: .default) { _ in
                                            guard let detail = self.detail else { return }
                                            let tintColor = ParkArea(rawValue: detail.parent.area)?.tintColor ?? GlobalColor.primaryRed
                                            let favorite = DB.FavoriteModel(park: self.park,
                                                                            str_id: self.attractionId,
                                                                            lang: .cn,
                                                                            name: detail.parent.name,
                                                                            thum: detail.parent.images[0],
                                                                            area: detail.parent.area,
                                                                            tintColor: tintColor.hex)
                                            DB.insert(favorite: favorite)
        }
        let cancelCollectAction = UIAlertAction(title: localize(for: "Cancel favorite"),
                                                style: .default) { _ in
                                                    DB.delete(favoriteId: self.attractionId)
        }
        let cancelAction = UIAlertAction(title: localize(for: "Cancel"),
                                         style: .cancel,
                                         handler: nil)
        if DB.exists(favoriteId: attractionId) {
            alertController.addAction(cancelCollectAction)
        } else {
            alertController.addAction(collectAction)
        }

        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    private func requestAttractionDetail() {
        let detailRequest = API.Attractions.detail(park: park, id: attractionId)

        detailRequest.request(AttractionDetail.self) { [weak self] (detail, _) in
            guard let strongSelf = self else { return }

            if let detail = detail {
                strongSelf.dataFetched.detail = true
                strongSelf.detail = AnalysedAttractionDetail(parent: detail)
            }
            if strongSelf.dataFetched.ready {
                strongSelf.collectionView.reloadData()
            }
        }
    }

    private func requestWaitTime() {
        let waitTimeRequest = API.Attractions.waitTime(park: park, id: attractionId, date: nil)

        waitTimeRequest.request(WaitTime.self) { [weak self](waitTime, _) in
            guard let strongSelf = self else { return }
            strongSelf.dataFetched.waitTime = true
            if let waitTime = waitTime {
                strongSelf.waitTime = AnalysedWaitTime(parent: waitTime)
            }
            if strongSelf.dataFetched.ready {
                strongSelf.collectionView.reloadData()
            }
        }
    }

    private func addNavButtons() {

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

        let rightButton = UIButton(type: .custom)
        rightButton.addTarget(self, action: #selector(rightButtonPressed(_:)), for: .touchUpInside)
        rightButton.setImage(#imageLiteral(resourceName: "ic_more_horiz_black_24px"), for: .normal)
        rightButton.setImage(#imageLiteral(resourceName: "ic_more_horiz_black_24px"), for: .highlighted)
        let rightItem = UIBarButtonItem(customView: rightButton)

        navigationItem.leftBarButtonItem = backbuttonItem
        navigationItem.rightBarButtonItem = rightItem

        customizeNavigationBar.items = [navigationItem]

    }

    private struct DataFetched {
        var detail: Bool
        var waitTime: Bool

        init() {
            detail = false
            waitTime = false
        }

        var ready: Bool {
            return detail && waitTime
        }
    }

}

extension AttractionDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        case 1:
            if waitTime != nil {
                return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            } else {
                return .zero
            }
        case 2:
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = CGFloat(414) / CGFloat(192)
            let height = screenWidth / ratio
            return CGSize(width: screenWidth, height: height)
        } else if indexPath.section == 1 {
            let screenWidth = UIScreen.main.bounds.width
            let height = (UIScreen.main.bounds.width - 24) * 0.5
            return CGSize(width: screenWidth, height: height)
        } else {
            if indexPath.item == 0 {
                if let detail = detail {
                    return AttractionNoteCell.autoLayoutSize(detail: detail)
                } else {
                    return .zero
                }
            } else {
                if let payload = detail?.payloads[indexPath.item - 1] {
                    return AttractionOtherCell.autoLayoutSize(payload: payload)
                } else {
                    return .zero
                }
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !dataFetched.ready {
            return 0
        } else {
            if let detail = detail {
                switch section {
                case 0:
                    return 1
                case 1:
                    if waitTime != nil {
                        return 1
                    } else {
                        return 0
                    }
                case 2:
                    return 1 + detail.payloads.count
                default:
                    return 0
                }
            } else {
                return 0
            }
        }
    }

    //swiftlint:disable force_cast
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! AttractionImageCell
            cell.detail = detail
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chartCellIdentifier, for: indexPath) as! AttractionChartCell
            cell.data = waitTime
            return cell
        } else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noteCellIdentifier, for: indexPath) as! AttractionNoteCell
                cell.detail = detail
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherCellIdentifier, for: indexPath) as! AttractionOtherCell
                cell.payload = detail?.payloads[indexPath.item - 1]
                return cell
            }
        }
    }
}

class AnalysedAttractionDetail: Localizable {

    let localizeFileName = "Attraction"
    let parent: AttractionDetail

    private var appropriateFor = [String]()
    private var barrierFree = [String]()
    private var attractionType = [String]()
    private var fastpassAttraction = [String]()
    private var limited = [String]()
    private var capacity = [String]()
    private var duration = [String]()

    var payloads = [Payload]()

    init(parent: AttractionDetail) {
        self.parent = parent
        analysis()
    }

    enum PayloadType {
        case attractionType
        case barrierFree
        case appropriateFor
        case fastpassAttraction
        case limited
        case capacity
        case duration
    }

    struct Payload {
        let type: PayloadType
        let title: String
        let content: String
    }

    private func analysis() {
        for tag in parent.summary_tags {
            if keys(for: .barrierFree).contains(tag.type) {
                barrierFree.append(contentsOf: tag.tags)
            } else if keys(for: .appropriateFor).contains(tag.type) {
                appropriateFor.append(contentsOf: tag.tags)
            } else if keys(for: .attractionType).contains(tag.type) {
                attractionType.append(contentsOf: tag.tags)
            } else {
                if let tag0 = tag.tags.first {
                    if keys(for: .fastpassAttraction).contains(tag0) {
                        fastpassAttraction.append(contentsOf: tag.tags)
                    }
                }
            }
        }
        if let limitTags = parent.limited {
            limited.append(contentsOf: limitTags)
        }
        if let summaries = parent.summaries {
            for summary in summaries {
                if keys(for: .capacity).contains(summary.title) {
                    capacity.append(summary.body)
                } else if keys(for: .duration).contains(summary.title) {
                    duration.append(summary.body)
                }
            }
        }
        if let payload = detail(for: .appropriateFor) {
            payloads.append(payload)
        }
        if let payload = detail(for: .barrierFree) {
            payloads.append(payload)
        }
        if let payload = detail(for: .attractionType) {
            payloads.append(payload)
        }
        if let payload = detail(for: .capacity) {
            payloads.append(payload)
        }
        if let payload = detail(for: .duration) {
            payloads.append(payload)
        }
        if let payload = detail(for: .limited) {
            payloads.append(payload)
        }
        if let payload = detail(for: .fastpassAttraction) {
            payloads.append(payload)
        }
    }

    //swiftlint:disable:next function_body_length
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
        case .attractionType:
            if !attractionType.isEmpty {
                let key = localize(for: "Attraction type")
                let value = attractionType.joined(separator: "\n")
                return Payload(type: .attractionType, title: key, content: value)
            } else {
                return nil
            }
        case .capacity:
            if !capacity.isEmpty {
                let key = localize(for: "Capacity")
                let value = attractionType.joined(separator: "\n")
                return Payload(type: .capacity, title: key, content: value)
            } else {
                return nil
            }
        case .duration:
            if !duration.isEmpty {
                let key = localize(for: "Duration")
                let value = attractionType.joined(separator: "\n")
                return Payload(type: .duration, title: key, content: value)
            } else {
                return nil
            }
        case .limited:
            if !limited.isEmpty {
                let key = localize(for: "Boarding Restrictions")
                let value = attractionType.joined(separator: "\n")
                return Payload(type: .limited, title: key, content: value)
            } else {
                return nil
            }
        case .fastpassAttraction:
            if !fastpassAttraction.isEmpty {
                let key = localize(for: "FASTPASS Attraction")
                let value = attractionType.joined(separator: "\n")
                return Payload(type: .fastpassAttraction, title: key, content: value)
            } else {
                return nil
            }
        }
    }

    private func keys(for property: PayloadType) -> Set<String> {
        switch property {
        case .appropriateFor:
            return Set(["Appropriate for", "对象", "適合對象"])
        case .barrierFree:
            return Set(["Barrier Free", "游园无障碍", "無障礙資訊"])
        case .attractionType:
            return Set(["Attraction Type", "游乐设施分类", "遊樂設施特色"])
        case .fastpassAttraction:
            return Set(["FASTPASS Attraction", "ファストパス対象", "采用快速通行的游乐设施", "適用迪士尼快速通行"])
        case .capacity:
            return Set(["Capacity", "定員", "定员", "乘載人數"])
        case .duration:
            return Set(["Duration", "所要時間", "所需时间", "所需時間"])
        default:
            return Set<String>()
        }
    }
}

struct AnalysedWaitTime {

    let date: Date
    let type: AttractionDetailWaitTimeType

    // 预测时间与实际时间至少存在一个
    // 从8:00开始至22:00结束，每15分钟一个数据，依次对应数组下标的0...56
    let prediction: [WaitTime.Prediction?]?
    let realtime: [WaitTime.RealTime?]?

    // 第一个实时数据的位置
    private(set) var firstRealtimeIndex: Int?
    // 最后一个实时数据的位置
    private(set) var lastRealtimeIndex: Int?
    // 运营结束时的位置
    private(set) var maxIndex: Int?

    // 最大值的档位：30, 60, 90...
    private(set) var scale: Int = 30

    init?(parent: WaitTime) {
        date = parent.datetime

        var emptyPrediction = true
        var emptyRealtime = true

        let ps = parent.prediction
        if !ps.isEmpty {
            var tps: [WaitTime.Prediction?] = Array(repeating: nil, count: 57)
            ps.forEach { tps[$0.index] = $0 }
            prediction = tps
            emptyPrediction = false
        } else {
            prediction = nil
            emptyPrediction = true
        }

        let rs = parent.realtime
        if !rs.isEmpty {
            var trs: [WaitTime.RealTime?] = Array(repeating: nil, count: 57)
            rs.forEach { trs[$0.index] = $0 }
            realtime = trs
            emptyRealtime = false
        } else {
            realtime = nil
            emptyRealtime = true
        }

        switch (emptyPrediction, emptyRealtime) {
        case (true, true):
            return nil
        case (true, false):
            type = .realtimeOnly
        case (false, true):
            type = .simOnly
        case (false, false):
            type = .mix
        }

        let analysis = analyseRealtime()
        firstRealtimeIndex = analysis.firstRealtimeIndex
        lastRealtimeIndex = analysis.lastRealtimeIndex
        maxIndex = analysis.maxIndex

        scale = analyseScale()
    }

    /// 分析实时数据：获取实时信息开始点，实时信息结束点，停运时间点
    ///
    /// - Returns: (实时信息开始点，实时信息结束点，停运时间点)
    private func analyseRealtime() -> RealtimeAnalyseResult {
        if let rt = realtime {
            // 实时信息存在
            let numberOfValues = rt.count
            // first index
            var iFirstIndex: Int?
            var lastAvailableOperationEnd: Date?
            for index in 0..<numberOfValues {
                if let data = rt[index] {
                    iFirstIndex = index
                    lastAvailableOperationEnd = data.operationEnd
                    break
                }
            }
            guard let firstIndex = iFirstIndex else {
                return RealtimeAnalyseResult(firstRealtimeIndex: nil, lastRealtimeIndex: nil, maxIndex: nil)
            }

            // last index
            var lastIndex = firstIndex
            var lastRunning = true
            if firstIndex + 1 < numberOfValues {
                for index in (firstIndex + 1)..<numberOfValues {
                    if let data = rt[index] {
                        lastIndex = index
                        lastRunning = data.running
                        lastAvailableOperationEnd = data.operationEnd
                    }
                }
            }

            // 如果最后一条可用信息时，项目处于停运状态
            if !lastRunning {
                return RealtimeAnalyseResult(firstRealtimeIndex: firstIndex, lastRealtimeIndex: lastIndex, maxIndex: lastIndex)
            }

            // stop index
            if let laoe = lastAvailableOperationEnd, let laoeIndex = laoe.waitTimeIndex {
                return RealtimeAnalyseResult(firstRealtimeIndex: firstIndex, lastRealtimeIndex: lastIndex, maxIndex: laoeIndex)
            } else {
                return RealtimeAnalyseResult(firstRealtimeIndex: firstIndex, lastRealtimeIndex: lastIndex, maxIndex: 56)
            }
        } else {
            return RealtimeAnalyseResult(firstRealtimeIndex: nil, lastRealtimeIndex: nil, maxIndex: nil)
        }
    }

    private func analyseScale() -> Int {
        var scale = 30
        if let simData = prediction {
            let skip = lastRealtimeIndex ?? -1
            let simScale = simData.reduce(30) { (res, data) -> Int in
                if let data = data, data.index > skip, data.waitTime > res {
                    return ((data.waitTime - 1) / 30 + 1) * 30
                } else {
                    return res
                }
            }
            scale = max(scale, simScale)
        }
        if let realData = realtime {
            let realScale = realData.reduce(30) { (res, data) -> Int in
                if let data = data, data.waitTime > res {
                    return ((data.waitTime - 1) / 30 + 1) * 30
                } else {
                    return res
                }
            }
            scale = max(scale, realScale)
        }
        return scale
    }

    private struct RealtimeAnalyseResult {
        let firstRealtimeIndex: Int?
        let lastRealtimeIndex: Int?
        let maxIndex: Int?
    }

    enum AttractionDetailWaitTimeType {
        case realtimeOnly
        case simOnly
        case mix
    }
}
