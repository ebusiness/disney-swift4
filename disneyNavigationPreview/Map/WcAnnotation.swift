//
//  WcAnnotation.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/03/01.
//  Copyright © 2018 ebuser. All rights reserved.
//

import MapKit
import UIKit

class WcAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    let attraction: Attraction

    init?(attraction: Attraction) {
        self.attraction = attraction
        self.title = attraction.name
        self.subtitle = attraction.introductions
        guard let latitude = attraction.coordinates?[0],
            let longitude = attraction.coordinates?[1] else { return nil }
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        super.init()
    }
}

class WcAnnotationView: MKMarkerAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        markerTintColor = GlobalColor.primaryRed

        glyphImage = #imageLiteral(resourceName: "ic_wc_black_36px")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
