//
//  ShowImageCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/2.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class ShowImageCell: UICollectionViewCell {
    var detail: AnalysedShowDetail? {
        didSet {
            if let imagePath = detail?.parent.images.first, let url = ImageAccessUrl(string: imagePath) {
                imageView.af_setImage(withURLRequest: url)
            } else {
                imageView.image = nil
            }
        }
    }

    private let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        super.init(frame: frame)

        addSubImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
