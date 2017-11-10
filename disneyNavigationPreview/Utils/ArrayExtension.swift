//
//  ArrayExtension.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/10.
//  Copyright © 2017 ebuser. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
