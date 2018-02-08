//
//  FilterPicker.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/02/07.
//  Copyright © 2018 ebuser. All rights reserved.
//

import RxSwift
import UIKit

class MapFilterPickerVC: UIViewController {

    private let disposeBag = DisposeBag()
    private let touchGesture: UILongPressGestureRecognizer
    private let mapFilterPicker: MapFilterPicker
    let currentFilter: Variable<MapVC.AnnotationType>

    init(filter: MapVC.AnnotationType) {
        touchGesture = UILongPressGestureRecognizer()
        mapFilterPicker = MapFilterPicker(filter: filter)
        currentFilter = Variable(filter)
        super.init(nibName: nil, bundle: nil)

        touchGesture.minimumPressDuration = 0
        touchGesture.addTarget(self, action: #selector(handleLongGesture(gesture:)))
        touchGesture.cancelsTouchesInView = false
        touchGesture.delegate = self
        view.addGestureRecognizer(touchGesture)

        modalPresentationStyle = .overCurrentContext
        view.backgroundColor = GlobalColor.popUpBackground
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubMapFilterPicker()
    }

    private func addSubMapFilterPicker() {
        view.addSubview(mapFilterPicker)
        mapFilterPicker.translatesAutoresizingMaskIntoConstraints = false
        mapFilterPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapFilterPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapFilterPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        mapFilterPicker
            .currentFilter
            .asObservable()
            .subscribe(onNext: { [weak self] park in
                self?.currentFilter.value = park
            })
            .disposed(by: disposeBag)
    }

    @objc
    private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            if !mapFilterPicker.frame.contains(gesture.location(in: view)) {
                dismiss(animated: false, completion: nil)
            }
        }
    }
}

extension MapFilterPickerVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if mapFilterPicker.frame.contains(gestureRecognizer.location(in: view)) {
            return false
        } else {
            return true
        }
    }
}

final class MapFilterPicker: UIView, Localizable {

    let localizeFileName = "Map"

    private let title: UILabel
    private let labelHot: UILabel
    private let labelAll: UILabel
    private let stackView: UIStackView
    private let textSurrounding: TextSurrounding
    private let touchGesture: UILongPressGestureRecognizer

    let currentFilter: Variable<MapVC.AnnotationType>

    init(filter: MapVC.AnnotationType) {
        title = UILabel()
        labelHot = UILabel()
        labelAll = UILabel()
        stackView = UIStackView(arrangedSubviews: [title, labelHot, labelAll])

        let textSurroundingSize = CGSize(width: 220, height: 34)
        let screenSize = UIScreen.main.bounds.size
        let textSurroundingY: CGFloat
        switch filter {
        case .hot:
            textSurroundingY = 70 + (70 - textSurroundingSize.height) / 2
        case .all:
            textSurroundingY = 140 + (70 - textSurroundingSize.height) / 2
        }
        textSurrounding = TextSurrounding(frame: CGRect(x: (screenSize.width - textSurroundingSize.width) / 2,
                                                        y: textSurroundingY,
                                                        width: textSurroundingSize.width,
                                                        height: textSurroundingSize.height))

        currentFilter = Variable(filter)
        touchGesture = UILongPressGestureRecognizer()
        super.init(frame: .zero)
        backgroundColor = BaseInfoColor.baseInfoViewBackground
        addSubStackView()
        addSubTextSurrounding()
        addTouchGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 210)
    }

    private func addSubStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        title.textAlignment = .center
        title.text = localize(for: "choose filter")
        title.textColor = BaseInfoColor.baseInfoPickerGray
        labelHot.textAlignment = .center
        labelHot.text = localize(for: "filter hot")
        labelHot.textColor = BaseInfoColor.baseInfoPickerBlack
        labelAll.textAlignment = .center
        labelAll.text = localize(for: "filter all")
        labelAll.textColor = BaseInfoColor.baseInfoPickerBlack
    }

    private func addSubTextSurrounding() {
        addSubview(textSurrounding)
    }

    private func addTouchGesture() {
        touchGesture.minimumPressDuration = 0
        touchGesture.addTarget(self, action: #selector(handleLongGesture(gesture:)))
        touchGesture.cancelsTouchesInView = false
        touchGesture.delegate = self
        addGestureRecognizer(touchGesture)
    }

    @objc
    private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            if labelHot.frame.contains(gesture.location(in: self)) {
                moveSurrounding(to: .hot, animate: true)
            } else {
                moveSurrounding(to: .all, animate: true)
            }
        }
    }

    func moveSurrounding(to filter: MapVC.AnnotationType, animate: Bool) {
        if currentFilter.value == filter {
            return
        }
        let center: CGPoint
        switch filter {
        case .hot:
            center = labelHot.center
        case .all:
            center = labelAll.center
        }
        if animate {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: { [weak self] in
                            self?.textSurrounding.center = center
            })
        } else {
            textSurrounding.center = center
        }
        currentFilter.value = filter
    }

}

extension MapFilterPicker: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if title.frame.contains(gestureRecognizer.location(in: self)) {
            return false
        } else {
            return true
        }
    }
}
