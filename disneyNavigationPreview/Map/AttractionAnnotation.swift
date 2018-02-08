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

class AttractionAnnotationView: MKMarkerAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        markerTintColor = GlobalColor.primaryRed

        glyphImage = #imageLiteral(resourceName: "ferris")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        willSet {
            guard let attractionAnnotation = newValue as? AttractionAnnotation else { return }
            canShowCallout = true
            let leftView = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 18, height: 200)))
            leftView.backgroundColor = GlobalColor.primaryRed
            leftCalloutAccessoryView = leftView

            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tintColor = GlobalColor.primaryRed
            rightButton.addTarget(self, action: #selector(rightButtonPressed(_:)), for: .touchUpInside)
            rightCalloutAccessoryView = rightButton

            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = attractionAnnotation.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }

    @objc
    private func rightButtonPressed(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let tabVC = appDelegate.window?.rootViewController as? TabVC else { return }
        guard let mapVC = (tabVC.viewControllers?[2] as? UINavigationController)?.topViewController as? MapVC else { return }
        guard let attraction = (annotation as? AttractionAnnotation)?.attraction else { return }
        mapVC.pushToDetail(attraction: attraction)
    }

}
