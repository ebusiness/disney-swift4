//
//  RightImageButton.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/10/24.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class RightImageButton: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var titleRect = super.titleRect(forContentRect: contentRect)
        let imageRect = super.imageRect(forContentRect: contentRect)
        titleRect.origin.x = imageRect.origin.x
        return titleRect
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        var imageRect = super.imageRect(forContentRect: contentRect)
        imageRect.origin.x = titleRect.origin.x + titleRect.size.width - imageRect.size.width
        return imageRect
    }

}
