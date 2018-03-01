//
//  FloatButtonView.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/03/01.
//  Copyright © 2018 ebuser. All rights reserved.
//

import RxSwift
import UIKit

class FloatButtonView: UIView {

    let buttonPressed = PublishSubject<Int>()

    var state = State.closed {
        didSet {
            switch state {
            case .closed:
                closeButtons()
            case .open:
                openButtons()
            }
        }
    }

    let π = CGFloat.pi
    let buttonCount: Int
    let viewSize: CGSize
    let margin: CGFloat = 8
    var miniButtons = [UIButton]()
    var mainButton: UIButton!

    init(buttonCount: Int,
         size: CGSize = CGSize(width: 200, height: 200)) {
        assert(buttonCount > 1, "At least 2 buttons is needed!")
        self.buttonCount = buttonCount
        viewSize = size
        super.init(frame: CGRect(origin: .zero,
                                 size: size))
        addSubViews()
        addSubButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return viewSize
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        } else {
            return hitView
        }
    }

    private func addSubViews() {
        mainButton = UIButton(type: .custom)
        mainButton.setImage(#imageLiteral(resourceName: "float_button"), for: .normal)
        mainButton.setImage(#imageLiteral(resourceName: "float_button"), for: .highlighted)

        mainButton.frame = CGRect(origin: CGPoint(x: viewSize.width - margin - mainButton.intrinsicContentSize.width,
                                                  y: viewSize.height - margin - mainButton.intrinsicContentSize.height),
                                  size: mainButton.intrinsicContentSize)
        addSubview(mainButton)

        mainButton.addTarget(self, action: #selector(mainButtonPressed(_:)), for: .touchUpInside)
    }

    private func addSubButtons() {
        for i in 0..<buttonCount {
            let button = UIButton(type: .custom)
            button.tintColor = UIColor.white
            button.tag = i
            button.addTarget(self, action: #selector(miniButtonPressed(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 20
            button.layer.masksToBounds = true
            button.backgroundColor = UIColor(baseColor: GlobalColor.primaryRed, alpha: 0.85)
            button.frame.size = CGSize(width: 40, height: 40)
            miniButtons.append(button)
        }
    }

    @objc
    private func mainButtonPressed(_ sender: UIButton) {
        switch state {
        case .closed:
            state = .open
        case .open:
            state = .closed
        }
    }

    private func openButtons() {
        miniButtons.forEach {
            $0.center = mainButton.center
            addSubview($0)
        }
        bringSubview(toFront: mainButton)

        animateMiniButton0()
        animateMiniButtonOtherThan0()
    }

    private func animateMiniButton0() {
        let button = miniButtons[0]
        let startPosition = button.center
        let endPosition = CGPoint(x: margin + mainButton.intrinsicContentSize.width / 2,
                                  y: startPosition.y)
        let path = UIBezierPath()
        path.move(to: startPosition)
        path.addLine(to: endPosition)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            button.center = endPosition
        }
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 0.25
        animation.repeatCount = 0
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        button.layer.add(animation, forKey: "animate position along path")

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = 2 * π
        rotateAnimation.duration = 0.30
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false
        button.layer.add(rotateAnimation, forKey: "animate rotation")
        CATransaction.commit()
    }

    private func animateMiniButtonOtherThan0() {
        let r = viewSize.width - 2 * margin - 2 * mainButton.intrinsicContentSize.width / 2
        for i in 1..<buttonCount {
            let angle = π / 2 / CGFloat(buttonCount - 1) * CGFloat(i)
            let button = miniButtons[i]
            let startPosition = button.center
            let endPosition = CGPoint(x: mainButton.center.x - r * cos(angle),
                                      y: mainButton.center.y - r * sin(angle))
            let controlPoint1 = CGPoint(x: mainButton.center.x - 75,
                                        y: mainButton.center.y)
            let controlPoint2 = CGPoint(x: endPosition.x - 75 * sin(angle),
                                        y: endPosition.y + 75 * cos(angle))
            let path = UIBezierPath()
            path.move(to: startPosition)
            path.addCurve(to: endPosition,
                          controlPoint1: controlPoint1,
                          controlPoint2: controlPoint2)

            CATransaction.begin()
            CATransaction.setCompletionBlock {
                button.center = endPosition
            }
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = path.cgPath
            animation.duration = 0.25
            animation.repeatCount = 0
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            button.layer.add(animation, forKey: "animate position along path")

            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0
            rotateAnimation.toValue = 2 * π
            rotateAnimation.duration = 0.30
            rotateAnimation.fillMode = kCAFillModeForwards
            rotateAnimation.isRemovedOnCompletion = false
            button.layer.add(rotateAnimation, forKey: "animate rotation")
            CATransaction.commit()
        }
    }

    private func closeButtons() {
        // button0
        for i in 0..<buttonCount {
            let button = miniButtons[i]
            let startPosition = button.center
            let endPosition = mainButton.center

            let path = UIBezierPath()
            path.move(to: startPosition)
            path.addLine(to: endPosition)

            CATransaction.begin()
            CATransaction.setCompletionBlock {
                button.removeFromSuperview()
            }
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = path.cgPath
            animation.duration = 0.25
            animation.repeatCount = 0
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            button.layer.add(animation, forKey: "animate position along path")
            CATransaction.commit()
        }

    }

    @objc
    private func miniButtonPressed(_ sender: UIButton) {
        state = .closed
        buttonPressed.onNext(sender.tag)
    }

    enum State {
        case open
        case closed
    }

}
