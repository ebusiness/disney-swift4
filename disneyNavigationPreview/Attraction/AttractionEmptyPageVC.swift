//
//  AttractionEmptyPageVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/24.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class AttractionEmptyPageVC: UIViewController, Localizable {

    let localizeFileName = "Attraction"

    var status = AttractionPageVC.LoadingStatus.loading {
        didSet {
            switch status {
            case .loading:
                label.text = localize(for: "empty state loading")
            case .failed:
                label.text = localize(for: "empty state failed")
            case .success:
                label.text = nil
            }
        }
    }

    private let label: UILabel

    private var _callBack: (() -> Void)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        label = UILabel(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        addSubLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(pressed(_:)))
        gesture.minimumPressDuration = 0
        view.addGestureRecognizer(gesture)
    }

    private func addSubLabel() {
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = GlobalColor.noDataText
        label.text = localize(for: "empty state loading")
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -120).isActive = true
        } else {
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        }
    }

    @discardableResult
    func callback(_ callback: (() -> Void)?) -> AttractionEmptyPageVC {
        _callBack = callback
        return self
    }

    @objc
    private func pressed(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .ended:
            if view.bounds.contains(sender.location(in: view)) {
                _callBack?()
            }
        default:
            break
        }
    }

}
