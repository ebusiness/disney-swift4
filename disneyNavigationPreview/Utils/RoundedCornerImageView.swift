//
//  TopRoundedCornerImageView.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/22.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class TopRoundedCornerImageView: UIImageView {

    let cornerRadius: CGFloat

    init(frame: CGRect, cornerRadius: CGFloat = 10) {
        self.cornerRadius = cornerRadius
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topRight, .topLeft],
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

}

class LeftRoundedCornerImageView: UIImageView {
    let cornerRadius: CGFloat

    init(frame: CGRect, cornerRadius: CGFloat = 2) {
        self.cornerRadius = cornerRadius
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.bottomLeft, .topLeft],
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
