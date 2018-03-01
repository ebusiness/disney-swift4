//
//  ShowScheduleVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/19.
//  Copyright © 2018 ebuser. All rights reserved.
//

import RxSwift
import UIKit

class ShowScheduleVC: UIViewController, Localizable {

    let localizeFileName = "Timeline"

    let disposeBag = DisposeBag()

    private var timeline: AnalysedTimeline? {
        didSet {
            collectionView.reloadData()
            scrollToNow()
        }
    }

    private let collectionView: UICollectionView
    private let blackIdentifier = "blackIdentifier"
    private let whiteIdentifier = "whiteIdentifier"
    private let timelineLayout: TimeLineLayout

    var date = Date()
    var park = TokyoDisneyPark.land {
        didSet {
            if oldValue != park {
                updateNavigationLeftButton()
                requestTimeline()
            }
        }
    }

    lazy var firstAppear: Void = {
        scrollToNow()
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        timelineLayout = TimeLineLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: timelineLayout)
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
        updateNavigationLeftButton()
        updateNavigationRightButton()

        requestTimeline()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = firstAppear
    }

    private func requestTimeline() {
        let detailRequest = API.Show.list(park: park, date: date.dateStringInTokyo)

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

    private func updateNavigationRightButton() {
        let day = date.dayInTokyo

        if navigationItem.rightBarButtonItem == nil {
            let rightButton = UIButton(type: .custom)

            rightButton.addTarget(self,
                                  action: #selector(rightButtonPressed(_:)),
                                  for: .touchUpInside)

            rightButton.setBackgroundImage(#imageLiteral(resourceName: "date_empty"), for: .normal)
            rightButton.setBackgroundImage(#imageLiteral(resourceName: "date_empty"), for: .highlighted)
            let rightButtonTitle = NSAttributedString(string: day,
                                                      attributes: [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                                   NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10),
                                                                   NSAttributedStringKey.baselineOffset: -1])
            rightButton.setAttributedTitle(rightButtonTitle, for: .normal)
            rightButton.setAttributedTitle(rightButtonTitle, for: .highlighted)
            let rightItem = UIBarButtonItem(customView: rightButton)
            navigationItem.rightBarButtonItem = rightItem
        } else {
            guard let rightButton = navigationItem.rightBarButtonItem?.customView as? UIButton else { return }
            let rightButtonTitle = NSAttributedString(string: day,
                                                      attributes: [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                                   NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10),
                                                                   NSAttributedStringKey.baselineOffset: -1])
            rightButton.setAttributedTitle(rightButtonTitle, for: .normal)
            rightButton.setAttributedTitle(rightButtonTitle, for: .highlighted)
        }
    }

    @objc
    private func titleButtonPressed(_ sender: Any) {
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

    @objc
    private func rightButtonPressed(_ sender: UIButton) {
        let datePickerVC = ShowScheduleDatePickerVC(date: date)
        datePickerVC
            .currentDate
            .asObservable()
            .subscribe(onNext: { newDate in
                if self.date.dateStringInTokyo == newDate.dateStringInTokyo {
                    return
                }
                self.date = newDate
                self.updateNavigationRightButton()
                self.requestTimeline()
            })
            .disposed(by: disposeBag)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let tabVC = appDelegate.window?.rootViewController as? TabVC else { return }
        tabVC.present(datePickerVC,
                      animated: false)
    }

    private func scrollToNow() {
        let now = Date()
        guard let tokyoTime = now.hourInTokyo else { return }
        var topY = (tokyoTime - timelineLayout.startTime) * (timelineLayout.blackHeight + timelineLayout.blackLineSpacing)
        if topY < 0 {
            topY = 0
        } else if topY + collectionView.bounds.size.height > collectionView.contentSize.height {
            topY = collectionView.contentSize.height - collectionView.bounds.size.height
        }
        collectionView.contentOffset.y = topY
    }

    private func pushToDetail(park: TokyoDisneyPark, attractionId: String, attractionName: String) {
        let next = ShowDetailVC(park: park, attractionId: attractionId, attractionName: attractionName)
        navigationController?.pushViewController(next, animated: true)
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

    //swiftlint: disable: next function_body_length
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if let event = timeline?.events[safe: indexPath.section]?[safe: indexPath.item] {
            let alertController = UIAlertController(title: nil,
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
            // 详细
            let actionDetail = UIAlertAction(title: localize(for: "Detail"),
                                             style: .default,
                                             handler: { [unowned self] _ in
                                                self.pushToDetail(park: self.park, attractionId: event.id, attractionName: event.name)
            })

            // 闹钟提醒
            let actionAlarm = UIAlertAction(title: localize(for: "Set alarm"),
                                            style: .default,
                                            handler: { [unowned self] _ in
                                                // 保存
                                                let alarm = DB.AlarmModel(park: self.park,
                                                                          str_id: event.id,
                                                                          lang: .cn,
                                                                          name: event.name,
                                                                          time: event.startTime,
                                                                          thum: event.thum,
                                                                          identifier: event.identifier)
                                                DB.insert(alarm: alarm)
                                                // 设置闹钟
                                                UserNotification.current.addAlarm(alarm: alarm)
            })
            // 取消提醒
            let actionCancelAlarm = UIAlertAction(title: localize(for: "Cancel alarm"),
                                                  style: .default,
                                                  handler: { _ in
                                                    DB.delete(alarmIdentifier: event.identifier)
                                                    UserNotification.current.removeAlarm(identifier: event.identifier)
            })
            let actionCancel = UIAlertAction(title: localize(for: "Cancel"), style: .cancel, handler: nil)
            alertController.addAction(actionDetail)

            // 收藏
            let actionFavorite = UIAlertAction(title: localize(for: "Save favorite"),
                                               style: .default,
                                               handler: { [unowned self] _ in
                                                let favorite = DB.FavoriteModel(park: self.park,
                                                                                str_id: event.id,
                                                                                lang: .cn,
                                                                                name: event.name,
                                                                                thum: event.thum,
                                                                                area: event.area,
                                                                                tintColor: event.tintColor.hex)
                                                DB.insert(favorite: favorite)
            })
            // 取消收藏
            let actionCancelFavorite = UIAlertAction(title: localize(for: "Cancel favorite"),
                                                     style: .default,
                                                     handler: { _ in
                                                        DB.delete(favoriteId: event.id)
            })
            // 检查提醒是否已经设置
            if DB.exists(alarmIdentifier: event.identifier) {
                alertController.addAction(actionCancelAlarm)
            } else {
                actionAlarm.isEnabled = event.startTime > Date().addingTimeInterval(30 * 60)
                alertController.addAction(actionAlarm)
            }

            // 检查是否已经收藏
            if DB.exists(favoriteId: event.id) {
                alertController.addAction(actionCancelFavorite)
            } else {
                alertController.addAction(actionFavorite)
            }

            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)
        }
    }

}

struct AnalysedTimeline {
    let events: [[Event]]

    //swiftlint:disable:next function_body_length
    init(parent: [ShowTimeline]) {
        let filtered = parent.filter { !$0.schedules.isEmpty }
        if filtered.isEmpty {
            events = [[Event]]()
        } else {
            var allEvents = [Event]()
            let tokyoTimeNow = Date().hourInTokyo ?? 8
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

                    let outdated = startHour + durationHour < tokyoTimeNow
                    let event = Event(id: id,
                                      name: name,
                                      start: startHour,
                                      startTime: startDate,
                                      duration: durationHour,
                                      tintColor: tintColor,
                                      outdated: outdated,
                                      thum: timeline.thum,
                                      area: timeline.area)
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
        let startTime: Date
        let duration: CGFloat
        let tintColor: UIColor
        let outdated: Bool
        let thum: String
        let area: String
    }

}

extension AnalysedTimeline.Event {
    var identifier: String {
        return "alm" + id + startTime.dateTimeStringInTokyo
    }
}
