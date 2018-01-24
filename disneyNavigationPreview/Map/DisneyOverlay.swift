//
//  DisneyOverlay.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/19.
//  Copyright © 2018 ebuser. All rights reserved.
//

import MapKit

class DisneyOverlay: MKTileOverlay {
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let tilePath = Bundle.main.url(
            forResource: "\(path.y)",
            withExtension: "png",
            subdirectory: "tiles/\(path.z)/\(path.x)",
            localization: nil)

        guard let tile = tilePath else {
            return Bundle.main.url(
                forResource: "parchment",
                withExtension: "png",
                subdirectory: "tiles",
                localization: nil)!
        }
        return tile
    }
}
