//
//  MapVC.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/10.
//  Copyright © 2017 ebuser. All rights reserved.
//

import RxSwift
import MapKit
import UIKit

class MapVC: UIViewController {

    private let disposeBag = DisposeBag()

    let mapView: MKMapView
    let landRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.632305555677306, longitude: 139.8807945807259),
                                        span: MKCoordinateSpan(latitudeDelta: 0.0031998855382155966, longitudeDelta: 0.0033988731172485132))

    let seaRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.626019953443709, longitude: 139.88613796120461),
                                       span: MKCoordinateSpan(latitudeDelta: 0.0041349957124907633, longitudeDelta: 0.0067588443712338631))

    var lastValidRegion: MKCoordinateRegion?
    var currentRegionValid: Bool?

    var tileRenderer: MKTileOverlayRenderer!

    var annotationType: AnnotationType = .hot

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
                updateMapRegion()
                requestAttractionPoints()
            }
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        mapView = MKMapView()
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
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }

    private func updateNavigationTitle() {
        if navigationItem.titleView == nil {
            let button = RightImageButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "ic_repeat_black_24px"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "ic_repeat_black_24px"), for: .highlighted)
            button.setTitle(park.localize(), for: .normal)
            button.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
            navigationItem.titleView = button
        } else {
            guard let button = navigationItem.titleView as? UIButton else { return }
            button.setTitle(park.localize(), for: .normal)
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
        }
    }

    func pushToDetail(attraction: Attraction) {
        let next = AttractionDetailVC(park: park, attractionId: attraction.str_id ,attractionName: attraction.name)
        navigationController?.pushViewController(next, animated: true)
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

}

extension MapVC {
    enum AnnotationType {
        case all
        case hot
    }
}
