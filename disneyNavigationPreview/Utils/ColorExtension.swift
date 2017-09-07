//
//  ColorExtension.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        guard let hexInt = Int(hex, radix: 16) else {
            fatalError("Invalid hex string")
        }
        self.init(rgb: hexInt)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    convenience init(baseColor: UIColor, alpha: CGFloat) {
        assert(alpha >= 0 && alpha <= 1, "Invalid alpha value")

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        baseColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

struct GlobalColor {
    static let viewBackgroundLightGray = UIColor(white: 0.933, alpha: 1)
    static let popUpBackground = UIColor(white: 0, alpha: 0.33)
    static let seperatorGray = UIColor(white: 0.62, alpha: 1)
}
