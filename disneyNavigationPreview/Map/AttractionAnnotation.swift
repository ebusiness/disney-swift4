//
//  AttractionAnnotation.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/02/06.
//  Copyright © 2018 ebuser. All rights reserved.
//

import MapKit

class AttractionAnnotation: NSObject, MKAnnotation {

    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?

    init?(attraction: Attraction) {

        self.title = nil
        self.subtitle = attraction.name
        guard let latitude = attraction.coordinates?[0],
            let longitude = attraction.coordinates?[1] else { return nil }
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        super.init()
    }

}

class AttractionAnnotationView: MKMarkerAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        markerTintColor = GlobalColor.primaryRed

        glyphImage = #imageLiteral(resourceName: "ferris")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
