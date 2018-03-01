//
//  MapVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/10.
//  Copyright © 2017 ebuser. All rights reserved.
//

import CoreData
import RxSwift
import MapKit
import UIKit

class MapVC: UIViewController, Localizable {

    let localizeFileName = "Map"

    private let disposeBag = DisposeBag()

    let floatButtonView: FloatButtonView

    let mapView: MKMapView
    let landRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.632305555677306, longitude: 139.8807945807259),
                                        span: MKCoordinateSpan(latitudeDelta: 0.0031998855382155966, longitudeDelta: 0.0033988731172485132))

    let seaRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.626019953443709, longitude: 139.88613796120461),
                                       span: MKCoordinateSpan(latitudeDelta: 0.0041349957124907633, longitudeDelta: 0.0067588443712338631))

    var lastValidRegion: MKCoordinateRegion?
    var currentRegionValid: Bool?

    var tileRenderer: MKTileOverlayRenderer!

    let wcAnnotationIdentifier = "wcAnnotationIdentifier"
    let attractionAnnotationIdentifier = "attractionAnnotationIdentifier"
    let favoriteAnnotationIdentifier = "favoriteAnnotationIdentifier"

    var annotationType: AnnotationType = .hot {
        didSet {
            updateNavigationRightButton()
        }
    }

    var mapModifyLock = false
    lazy var setupCamera: Void = {
        //swiftlint:disable:next force_cast
        let camera = mapView.camera.copy() as! MKMapCamera
        camera.heading = 155
        mapView.camera = camera
    }()

    var park = TokyoDisneyPark.land {
        didSet {
            if oldValue != park {
                updateNavigationLeftButton()
                updateMapRegion()
                requestAttractionPoints()
            }
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        mapView = MKMapView()
        floatButtonView = FloatButtonView(buttonCount: 4)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = GlobalColor.primaryRed
        setupMapView()

        updateNavigationTitle()
        updateNavigationLeftButton()
        updateNavigationRightButton()

        requestAttractionPoints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = setupCamera
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func addSubViews() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            mapView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
            mapView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        }

        view.addSubview(floatButtonView)
        floatButtonView.translatesAutoresizingMaskIntoConstraints = false
        floatButtonView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        floatButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        floatButtonView
            .miniButtons
            .forEach { button in
                guard let type = AnnotationType(rawValue: button.tag) else { return }
                switch type {
                case .all:
                    button.setImage(#imageLiteral(resourceName: "map_type_all"), for: .normal)
                case .favorite:
                    button.setImage(#imageLiteral(resourceName: "map_type_favorite"), for: .normal)
                case .hot:
                    button.setImage(#imageLiteral(resourceName: "map_type_hot"), for: .normal)
                case .other:
                    button.setImage(#imageLiteral(resourceName: "ic_more_horiz_black_24px"), for: .normal)
                }
        }

        floatButtonView
            .buttonPressed
            .asObservable()
            .subscribe ({ [weak self] buttonTag in
                if let tag = buttonTag.element,
                    let type = AnnotationType(rawValue: tag) {
                    self?.annotationType = type
                }
                self?.requestAttractionPoints()
            })
            .disposed(by: disposeBag)

    }

    private func setupMapView() {

        setupTileRenderer()

        mapView.showsTraffic = false
        mapView.showsBuildings = false
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = false
        mapView.showsCompass = false
        mapView.isRotateEnabled = false
        mapView.delegate = self
        mapView.setRegion(landRegion, animated: false)

        mapView.register(AttractionAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: attractionAnnotationIdentifier)
        mapView.register(WcAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: wcAnnotationIdentifier)
        mapView.register(FavoriteAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: favoriteAnnotationIdentifier)
    }

    private func updateNavigationTitle() {
        title = localize(for: "title")
    }

    private func updateNavigationLeftButton() {

        if navigationItem.leftBarButtonItem == nil {
            let leftItem = UIBarButtonItem(title: park.short,
                                           style: .plain,
                                           target: self,
                                           action: #selector(titleButtonPressed(_:)))
            navigationItem.leftBarButtonItem = leftItem
        } else {
            guard let leftItem = navigationItem.leftBarButtonItem else { return }
            leftItem.title = park.short
        }

    }

    private func updateNavigationRightButton() {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        switch annotationType {
        case .all:
            label.text = localize(for: "filter all")
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: label)
        case .hot:
            label.text = localize(for: "filter hot")
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: label)
        case .favorite:
            label.text = localize(for: "filter favorite")
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: label)
        case .other:
            label.text = localize(for: "filter other")
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: label)
        }
    }

    private func setupTileRenderer() {
        let overlay = DisneyOverlay()

        overlay.canReplaceMapContent = true
        overlay.minimumZ = 17
        overlay.maximumZ = 19
        mapView.add(overlay, level: .aboveLabels)
        tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
    }

    private func updateMapRegion() {
        switch park {
        case .land:
            mapView.setRegion(landRegion, animated: false)
            //swiftlint:disable:next force_cast
            let camera = mapView.camera.copy() as! MKMapCamera
            camera.heading = 155
            mapView.camera = camera
        case .sea:
            mapView.setRegion(seaRegion, animated: false)
            //swiftlint:disable:next force_cast
            let camera = mapView.camera.copy() as! MKMapCamera
            camera.heading = 280
            mapView.camera = camera
        }
    }

    @objc
    private func titleButtonPressed(_ sender: UIButton) {
        let parkpicker = BaseInfoParkPickVC(park: park)
        parkpicker
            .currentPark
            .asObservable()
            .subscribe(onNext: { [weak self] park in
                self?.park = park
            })
            .disposed(by: disposeBag)
        guard let tabVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else { return }
        tabVC.present(parkpicker, animated: false)
    }

    private func requestAttractionPoints() {
        mapView.removeAnnotations(mapView.annotations)
        switch annotationType {
        case .all:
            let attractionListRequest = API.Attractions.list(park: park)
            attractionListRequest.request([Attraction].self) { [weak self] (objs, _) in
                guard let strongSelf = self else { return }
                if let objs = objs {
                    let attractions = objs.filter { $0.category == "attraction" }
                    let annotations = attractions.flatMap { AttractionAnnotation(attraction: $0) }
                    strongSelf.mapView.addAnnotations(annotations)
                }
            }
        case .hot:
            let attractionListRequest = API.Attractions.hot(park: park)
            attractionListRequest.request([Attraction].self) { [weak self] (objs, _) in
                guard let strongSelf = self else { return }
                if let objs = objs {
                    let attractions = objs.filter { $0.category == "attraction" } .prefix(10)
                    let annotations = attractions.flatMap { AttractionAnnotation(attraction: $0) }
                    strongSelf.mapView.addAnnotations(annotations)
                }
            }
        case .favorite:
            guard let fav = requestFavorite() else { return }
            let attractionListRequest = API.Attractions.list(park: park)

            attractionListRequest.request([Attraction].self) { [weak self] (objs, _) in
                guard let strongSelf = self else { return }
                if let objs = objs {
                    let attractions = objs.filter {
                        let str_id = $0.str_id
                        return $0.category == "attraction"
                            && fav.contains(where: { $0.str_id == str_id })
                    }
                    let annotations = attractions.flatMap { AttractionAnnotation(attraction: $0) }
                    strongSelf.mapView.addAnnotations(annotations)
                }
            }
        case .other:
            let attractionListRequest = API.Attractions.hot(park: park)
            attractionListRequest.request([Attraction].self) { [weak self] (objs, _) in
                guard let strongSelf = self else { return }
                if let objs = objs {
                    let attractions = objs.filter { $0.category == "attraction" } .suffix(10)
                    let annotations = attractions.flatMap { AttractionAnnotation(attraction: $0) }
                    strongSelf.mapView.addAnnotations(annotations)
                }
            }
        }
    }

    func pushToDetail(attraction: Attraction) {
        let next = AttractionDetailVC(park: park, attractionId: attraction.str_id ,attractionName: attraction.name)
        navigationController?.pushViewController(next, animated: true)
    }

    private func requestFavorite() -> [Favorite]? {
        guard let moc = DB.context else { return nil }
        let request = NSFetchRequest<Favorite>(entityName: "Favorite")

        do {
            return try moc.fetch(request)
        } catch {
            return nil
        }
    }
}

extension MapVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return tileRenderer
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !mapModifyLock && mapView.camera.altitude > 2662 {
            mapModifyLock = true
            mapView.camera.altitude = 2662
            mapModifyLock = false
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotationType {
        case .favorite:
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: favoriteAnnotationIdentifier, for: annotation)
            return annotationView
        case .other:
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: wcAnnotationIdentifier, for: annotation)
            return annotationView
        default:
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: attractionAnnotationIdentifier, for: annotation)
            return annotationView
        }
    }

}

extension MapVC {
    enum AnnotationType: Int {
        case all = 0
        case hot = 1
        case favorite = 2
        case other = 3
    }
}
