//
//  AttractionImageCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/06.
//  Copyright © 2017 ebuser. All rights reserved.
//

import UIKit

class AttractionImageCell: UICollectionViewCell {
    var detail: AnalysedAttractionDetail? {
        didSet {
            if let imagePath = detail?.parent.images.first, let url = URL(string: imagePath) {
                imageView.af_setImage(withURL: url)
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
