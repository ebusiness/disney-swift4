//
//  AttractionPageVCViewController.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/19.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

final class AttractionPageVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    let pageViewController: UIPageViewController

    let attractionVC: AttractionVC
    let showVC: ShowVC
    let greetingVC: GreetingVC

    let banner: PageBanner

    init() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal)
        attractionVC = AttractionVC()
        showVC = ShowVC()
        greetingVC = GreetingVC()

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
        pageViewController.setViewControllers([attractionVC], direction: .forward, animated: false)
        banner.switchTo(index: 0)

        requestAttractionList()
    }

    //swiftlint:disable:next cyclomatic_complexity
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

    private func requestAttractionList() {
        let attractionListRequest = API.Attractions.list

        attractionListRequest.request([Attraction].self) { [weak self] (objs, _) in
            guard let strongSelf = self else { return }
            if let objs = objs {
                var attractions = [Attraction]()
                var shows = [Attraction]()
                var greetings = [Attraction]()
                objs.forEach({ obj in
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
            }
        }
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
        case showVC:
            banner.switchTo(index: 1)
        case greetingVC:
            banner.switchTo(index: 2)
        default:
            break
        }
    }
}

class PageBanner: UIView {

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
    func callback(_ callback: ((_ index: Int) -> Void)?) -> PageBanner {
        _callBack = callback
        return self
    }

}

class BannerLabel: UILabel {

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
    func callback(_ callback: ((_ index: Int) -> Void)?) -> BannerLabel {
        _callBack = callback
        return self
    }
}
