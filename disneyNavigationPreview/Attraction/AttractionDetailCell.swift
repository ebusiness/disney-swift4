//
//  AttractionDetailCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/14.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import AlamofireImage
import UIKit

final class AttractionDetailImageCell: UITableViewCell {

    var images: [String]? {
        didSet {
            if let images = images, !images.isEmpty {
                let firstPage = PhotoViewController(imageURL: images[0], index: 0)
                pageController.setViewControllers([firstPage],
                                                  direction: .forward,
                                                  animated: false,
                                                  completion: nil)
                pageControl.numberOfPages = images.count
                pageControl.currentPage = 0
            }
        }
    }

    let pageController: UIPageViewController
    private let pageControl: UIPageControl

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        pageController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: [UIPageViewControllerOptionInterPageSpacingKey: 12])
        pageControl = UIPageControl(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        addSubPageController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubPageController() {
        pageController.delegate = self
        pageController.dataSource = self
        pageController.view.backgroundColor = GlobalColor.viewBackgroundLightGray
        addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pageController.view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        pageController.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pageController.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        pageControl.currentPageIndicatorTintColor = GlobalColor.primaryRed
        pageControl.pageIndicatorTintColor = AttractionColor.attractionPageIndicator
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: pageController.view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: pageController.view.bottomAnchor).isActive = true
    }

}

extension AttractionDetailImageCell: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //swiftlint:disable:next force_cast
        let viewController = viewController as! PhotoViewController
        if viewController.index == 0 {
            return nil
        } else {
            let prevIndex = viewController.index - 1
            let prev = PhotoViewController(imageURL: images![prevIndex], index: prevIndex)
            return prev
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //swiftlint:disable:next force_cast
        let viewController = viewController as! PhotoViewController
        let nextIndex = viewController.index + 1
        if let images = images, nextIndex < images.count {
            let next = PhotoViewController(imageURL: images[nextIndex], index: nextIndex)
            return next
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //swiftlint:disable:next force_cast
        let viewController = pageViewController.viewControllers![0] as! PhotoViewController
        pageControl.currentPage = viewController.index
    }

}

final class PhotoViewController: UIViewController {

    let imageURL: String
    let imageView: UIImageView
    let index: Int

    init(imageURL: String, index: Int) {
        self.imageURL = imageURL
        self.index = index
        imageView = UIImageView()
        super.init(nibName: nil, bundle: nil)

        view = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if let url = URL(string: imageURL) {
            imageView.af_setImage(withURL: url)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
