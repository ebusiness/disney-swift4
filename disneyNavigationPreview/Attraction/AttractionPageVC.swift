//
//  AttractionPageVCViewController.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/19.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import RxSwift
import UIKit

final class AttractionPageVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    let disposeBag = DisposeBag()

    let pageViewController: UIPageViewController

    let attractionVC: AttractionVC
    let showVC: ShowVC
    let greetingVC: GreetingVC
    let emptyVC: AttractionEmptyPageVC

    let banner: PageBanner

    lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_search_black_24px"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_search_black_24px"), for: .highlighted)
        button.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
        return button
    }()

    lazy var timelineButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_event_black_24px"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_event_black_24px"), for: .highlighted)
        button.addTarget(self, action: #selector(timelineButtonPressed(_:)), for: .touchUpInside)
        return button
    }()

    var park = TokyoDisneyPark.land {
        didSet {
            if oldValue != park {
                updateNavigationTitle()
                requestAttractionList()
            }
        }
    }

    var currentStatus = LoadingStatus.loading {
        didSet {
            if currentStatus != oldValue {
                switch currentStatus {
                case .failed:
                    emptyVC.status = .failed
                    if let currentVC = pageViewController.viewControllers?.first, currentVC == emptyVC {
                        break
                    } else {
                        pageViewController.setViewControllers([emptyVC], direction: .forward, animated: false)
                    }
                case .loading:
                    emptyVC.status = .loading
                    if let currentVC = pageViewController.viewControllers?.first, currentVC == emptyVC {
                        break
                    } else {
                        pageViewController.setViewControllers([emptyVC], direction: .forward, animated: false)
                    }
                case .success:
                    switch banner.currentIndex {
                    case 0:
                        pageViewController.setViewControllers([attractionVC], direction: .forward, animated: false)
                    case 1:
                        pageViewController.setViewControllers([showVC], direction: .forward, animated: false)
                    case 2:
                        pageViewController.setViewControllers([greetingVC], direction: .forward, animated: false)
                    default:
                        pageViewController.setViewControllers([attractionVC], direction: .forward, animated: false)
                    }
                }
            }
        }
    }

    enum LoadingStatus {
        case loading
        case success
        case failed
    }

    init() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal)
        attractionVC = AttractionVC()
        showVC = ShowVC()
        greetingVC = GreetingVC()
        emptyVC = AttractionEmptyPageVC()

        banner = PageBanner()
        super.init(nibName: nil, bundle: nil)

        pageViewController.delegate = self
        pageViewController.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = GlobalColor.viewBackgroundLightGray

        addSubBanner()
        addSubPageView()
        setupPageView()

        setupSubControllers()

        updateNavigationTitle()
        updateNavigationItem(to: 0)

        banner.switchTo(index: 0)

        requestAttractionList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func addSubBanner() {
        banner.callback { [weak self] (index) in
            guard let strongSelf = self else { return }
            guard let leaf = strongSelf.pageViewController.viewControllers?.first else { return }
            var currentIndex = -1
            switch leaf {
            case strongSelf.attractionVC:
                currentIndex = 0
            case strongSelf.showVC:
                currentIndex = 1
            case strongSelf.greetingVC:
                currentIndex = 2
            default:
                break
            }
            if currentIndex == -1 || currentIndex == index { return }
            strongSelf.updateNavigationItem(to: index)
            if index > currentIndex {
                if index == 1 {
                    strongSelf.pageViewController.setViewControllers([strongSelf.showVC], direction: .forward, animated: true)
                } else if index == 2 {
                    strongSelf.pageViewController.setViewControllers([strongSelf.greetingVC], direction: .forward, animated: true)
                }
            } else {
                if index == 0 {
                    strongSelf.pageViewController.setViewControllers([strongSelf.attractionVC], direction: .reverse, animated: true)
                } else if index == 1 {
                    strongSelf.pageViewController.setViewControllers([strongSelf.showVC], direction: .reverse, animated: true)
                }
            }
        }
        banner.setTitles([localize(for: "title attraction"),
                          localize(for: "title show"),
                          localize(for: "title greeting")])
        view.addSubview(banner)
        banner.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            banner.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            banner.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            banner.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
            banner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            banner.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
    }

    private func setupPageView() {
        emptyVC.callback { [weak self] in
            self?.requestAttractionList()
        }
        pageViewController.setViewControllers([emptyVC], direction: .forward, animated: false)
    }

    private func addSubPageView() {
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: banner.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            pageViewController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            pageViewController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            pageViewController.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        }
    }

    private func setupSubControllers() {
        showVC.pushToDetailCallback { [weak self] show in
            guard let strongSelf = self else { return }
            let next = ShowDetailVC(park: strongSelf.park, attractionId: show.str_id, attractionName: show.name)
            strongSelf.navigationController?.pushViewController(next, animated: true)
        }
        greetingVC.pushToDetailCallback { [weak self] attraction in
            guard let strongSelf = self else { return }
            let next = GreetingDetailVC(park: strongSelf.park, attraction: attraction)
            strongSelf.navigationController?.pushViewController(next, animated: true)
        }
        attractionVC.pushToDetailCallback { [weak self] attraction in
            guard let strongSelf = self else { return }
            let next = AttractionDetailVC(park: strongSelf.park, attraction: attraction)
            strongSelf.navigationController?.pushViewController(next, animated: true)
        }
    }

    private func requestAttractionList() {
        currentStatus = .loading
        let attractionListRequest = API.Attractions.list(park: park)

        attractionListRequest.request([Attraction].self) { [weak self] (objs, _) in
            guard let strongSelf = self else { return }
            if let objs = objs {
                var attractions = [Attraction]()
                var shows = [Attraction]()
                var greetings = [Attraction]()
                objs.forEach({ obj in
                    if !obj.is_available {
                        return
                    }
                    switch obj.category {
                    case "attraction":
                        attractions.append(obj)
                    case "show":
                        shows.append(obj)
                    case "greeting":
                        greetings.append(obj)
                    default:
                        break
                    }
                })
                strongSelf.attractionVC.reloadAllSpots(attractions)
                strongSelf.showVC.reloadAllSpots(shows)
                strongSelf.greetingVC.reloadAllSpots(greetings)
                strongSelf.currentStatus = .success
            } else {
                // error
                strongSelf.currentStatus = .failed
            }
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

    private func updateNavigationItem(to index: Int) {
        switch  index {
        case 0:
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        case 1:
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: timelineButton)
        case 2:
            navigationItem.rightBarButtonItem = nil
        default:
            navigationItem.rightBarButtonItem = nil
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

    @objc
    private func searchButtonPressed(_ sender: UIButton) {
        let searchController = AttractionSearchVC()
        navigationController?.pushViewController(searchController, animated: true)
    }

    @objc
    private func timelineButtonPressed(_ sender: UIButton) {
        let timelineVC = TimelineVC(park: park)
        let navigationVC = NavigationVC(rootViewController: timelineVC)
        present(navigationVC, animated: true)
    }
}

extension AttractionPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case attractionVC:
            return nil
        case showVC:
            return attractionVC
        case greetingVC:
            return showVC
        default:
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case attractionVC:
            return showVC
        case showVC:
            return greetingVC
        case greetingVC:
            return nil
        default:
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let current = pageViewController.viewControllers![0]
        switch current {
        case attractionVC:
            banner.switchTo(index: 0)
            updateNavigationItem(to: 0)
        case showVC:
            banner.switchTo(index: 1)
            updateNavigationItem(to: 1)
        case greetingVC:
            banner.switchTo(index: 2)
            updateNavigationItem(to: 2)
        default:
            break
        }
    }
}

final class PageBanner: UIView {

    var currentIndex = 0
    var labels = [BannerLabel]()
    private var _callBack: ((_ index: Int) -> Void)?

    init() {
        super.init(frame: .zero)
        backgroundColor = GlobalColor.viewBackgroundLightGray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitles(_ titles: [String]) {
        currentIndex = 0
        labels.forEach({ $0.removeFromSuperview() })
        labels.removeAll()

        if !titles.isEmpty {
            for idx in 0..<titles.count {
                let label = BannerLabel()
                    .callback({ [weak self] (index) in
                        self?.switchTo(index: index)
                        self?._callBack?(index)
                    })
                label.textAlignment = .center
                label.text = titles[idx]
                label.font = UIFont.systemFont(ofSize: 15)
                label.index = idx
                labels.append(label)
                addSubview(label)
            }
        }

        if !labels.isEmpty {

            for idx in 0..<labels.count {
                labels[idx].translatesAutoresizingMaskIntoConstraints = false
                labels[idx].topAnchor.constraint(equalTo: topAnchor).isActive = true
                labels[idx].bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                if idx == 0 {
                    labels[idx].leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                } else if idx == labels.count - 1 {
                    labels[idx].leftAnchor.constraint(equalTo: labels[idx - 1].rightAnchor).isActive = true
                    labels[idx].widthAnchor.constraint(equalTo: labels[idx - 1].widthAnchor).isActive = true
                    labels[idx].rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                } else {
                    labels[idx].leftAnchor.constraint(equalTo: labels[idx - 1].rightAnchor).isActive = true
                    labels[idx].widthAnchor.constraint(equalTo: labels[idx - 1].widthAnchor).isActive = true
                }
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 40)
    }

    func switchTo(index: Int) {
        currentIndex = index
        if !labels.isEmpty {
            UIView.animate(withDuration: 0.25,
                           animations: {
                            for idx in 0..<self.labels.count {
                                if idx == index {
                                    self.labels[idx].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.labels[idx].textColor = GlobalColor.primaryRed
                                } else {
                                    self.labels[idx].transform = .identity
                                    self.labels[idx].textColor = UIColor.black
                                }
                            }
            })
        }
    }

    @discardableResult
    func callback(_ callback: @escaping ((_ index: Int) -> Void)) -> PageBanner {
        _callBack = callback
        return self
    }

}

final class BannerLabel: UILabel {

    var index = 0
    private var _callBack: ((_ index: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = true
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pressed(_:)))
        gestureRecognizer.minimumPressDuration = 0
        addGestureRecognizer(gestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func pressed(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .ended:
            if bounds.contains(sender.location(in: self)) {
                _callBack?(index)
            }
        default:
            break
        }
    }

    @discardableResult
    func callback(_ callback: @escaping ((_ index: Int) -> Void)) -> BannerLabel {
        _callBack = callback
        return self
    }
}
