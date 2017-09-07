//
//  ParkPicker.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/6.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import RxSwift
import UIKit

final class ParkPicker: UIView, Localizable {

    let localizeFileName = "BaseInfo"

    private let title: UILabel
    private let labelLand: UILabel
    private let labelSea: UILabel
    private let stackView: UIStackView
    private let textSurrounding: TextSurrounding
    private let touchGesture: UILongPressGestureRecognizer

    let currentPark: Variable<TokyoDisneyPark>

    init(park: TokyoDisneyPark) {
        title = UILabel()
        labelLand = UILabel()
        labelSea = UILabel()
        stackView = UIStackView(arrangedSubviews: [title, labelLand, labelSea])

        let textSurroundingSize = CGSize(width: 220, height: 34)
        let screenSize = UIScreen.main.bounds.size
        let textSurroundingY: CGFloat
        switch park {
        case .land:
            textSurroundingY = 70 + (70 - textSurroundingSize.height) / 2
        case .sea:
            textSurroundingY = 140 + (70 - textSurroundingSize.height) / 2
        }
        textSurrounding = TextSurrounding(frame: CGRect(x: (screenSize.width - textSurroundingSize.width) / 2,
                                                        y: textSurroundingY,
                                                        width: textSurroundingSize.width,
                                                        height: textSurroundingSize.height))

        currentPark = Variable(park)
        touchGesture = UILongPressGestureRecognizer()
        super.init(frame: .zero)
        backgroundColor = GlobalColor.viewBackgroundLightGray
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
        title.text = localize(for: "choosePark")
        title.textColor = BaseInfoColor.baseInfoPickerGray
        labelLand.textAlignment = .center
        labelLand.text = TokyoDisneyPark.land.localize()
        labelLand.textColor = BaseInfoColor.baseInfoPickerBlack
        labelSea.textAlignment = .center
        labelSea.text = TokyoDisneyPark.sea.localize()
        labelSea.textColor = BaseInfoColor.baseInfoPickerBlack
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
            if labelLand.frame.contains(gesture.location(in: self)) {
                moveSurrounding(to: .land, animate: true)
            } else {
                moveSurrounding(to: .sea, animate: true)
            }
        }
    }

    func moveSurrounding(to park: TokyoDisneyPark, animate: Bool) {
        if currentPark.value == park {
            return
        }
        let center: CGPoint
        switch park {
        case .land:
            center = labelLand.center
        case .sea:
            center = labelSea.center
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
        currentPark.value = park
    }

}
extension ParkPicker: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if title.frame.contains(gestureRecognizer.location(in: self)) {
            return false
        } else {
            return true
        }
    }
}

final class TextSurrounding: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let newRect = CGRect(x: 1, y: 1, width: rect.width - 2, height: rect.height - 2)
        let rectanglePath = UIBezierPath(roundedRect: newRect, cornerRadius: newRect.height)
        UIColor.black.setStroke()
        rectanglePath.lineWidth = 1
        rectanglePath.stroke()
    }

}
