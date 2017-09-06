//
//  BaseInfoParkPickVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/6.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import RxSwift
import UIKit

final class BaseInfoParkPickVC: UIViewController {

    private let disposeBag = DisposeBag()
    private let touchGesture: UILongPressGestureRecognizer
    private let parkPicker: ParkPicker
    let currentPark: Variable<TokyoDisneyPark>

    init(park: TokyoDisneyPark) {
        touchGesture = UILongPressGestureRecognizer()
        parkPicker = ParkPicker(park: park)
        currentPark = Variable(park)
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
        addSubParkPicker()
    }

    private func addSubParkPicker() {
        view.addSubview(parkPicker)
        parkPicker.translatesAutoresizingMaskIntoConstraints = false
        parkPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        parkPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        parkPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        parkPicker
            .currentPark
            .asObservable()
            .subscribe(onNext: { [weak self] park in
                self?.currentPark.value = park
            })
            .disposed(by: disposeBag)
    }

    @objc
    private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            if !parkPicker.frame.contains(gesture.location(in: view)) {
                dismiss(animated: false, completion: nil)
            }
        }
    }

}

extension BaseInfoParkPickVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if parkPicker.frame.contains(gestureRecognizer.location(in: view)) {
            return false
        } else {
            return true
        }
    }
}
