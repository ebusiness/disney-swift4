//
//  TimelineVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/08.
//  Copyright © 2017 ebuser. All rights reserved.
//

import UIKit

class TimelineVC: UIViewController, Localizable {

    let localizeFileName = "Timeline"

    private let park: TokyoDisneyPark
    private var timeline: AnalysedTimeline? {
        didSet {
            collectionView.reloadData()
        }
    }

    private let collectionView: UICollectionView
    private let blackIdentifier = "blackIdentifier"
    private let whiteIdentifier = "whiteIdentifier"

    init(park: TokyoDisneyPark) {
        self.park = park
        let layout = TimeLineLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)

        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = GlobalColor.viewBackgroundLightGray
        setupNavigationBar()

        requestTimeline()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupNavigationBar() {
        let backbuttonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_clear_black_24px"), style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        navigationItem.leftBarButtonItem = backbuttonItem
        navigationItem.title = localize(for: "title")
    }

    @objc
    private func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    private func requestTimeline() {
        let now = Date()
        let detailRequest = API.Show.list(park: park, date: now.dateStringInTokyo)

        detailRequest.request([ShowTimeline].self) { [weak self](timelines, error) in
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

}

extension TimelineVC: UICollectionViewDelegateTimeLineLayout, UICollectionViewDataSource {
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

struct AnalysedTimeline {
    let events: [[Event]]

    init(parent: [ShowTimeline]) {
        let filtered = parent.filter { !$0.schedules.isEmpty }
        if filtered.isEmpty {
            events = [[Event]]()
        } else {
            var allEvents = [Event]()
            filtered.forEach({ timeline in
                let name = timeline.name
                let tintColor = ParkArea(rawValue: timeline.area)?.tintColor ?? GlobalColor.primaryRed
                let id = timeline.id
                timeline.schedules.forEach({ schedule in
                    guard let startDate = Date(iso8601str: schedule.startTime),
                        let endDate = Date(iso8601str: schedule.endTime) else { return }
                    var baseDateComponents = Calendar.current.dateComponents(in: .tokyoTimezone, from: startDate)
                    baseDateComponents.hour = 0
                    baseDateComponents.minute = 0
                    baseDateComponents.second = 0
                    guard let baseDate = Calendar.current.date(from: baseDateComponents) else { return }
                    let starttimeInterval = startDate.timeIntervalSince(baseDate)
                    let endtimeInterval = endDate.timeIntervalSince(baseDate)
                    // 持续时间小于15分钟的Show，按照15分钟的长度来显示
                    let durationtimeInterval = (endtimeInterval - starttimeInterval) > 900 ? (endtimeInterval - starttimeInterval) : 900
                    let startHour = CGFloat(starttimeInterval / 3600)
                    let durationHour = CGFloat(durationtimeInterval / 3600)

                    let event = Event(id: id, name: name, start: startHour, duration: durationHour, tintColor: tintColor)
                    allEvents.append(event)
                })
            })
            var eventConstructor = [[Event]](repeating: [Event](), count: 15)
            allEvents
                .sorted(by: { $0.start < $1.start })
                .forEach({ event in
                    let index = Int(event.start - 8)
                    guard index >= 0 && index <= 14 else { return }
                    eventConstructor[index].append(event)
                })
            events = eventConstructor
        }
    }

    struct Event {
        let id: String
        let name: String
        let start: CGFloat
        let duration: CGFloat
        let tintColor: UIColor
    }
}
