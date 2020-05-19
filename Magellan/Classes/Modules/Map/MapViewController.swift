//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import SoraUI
import GoogleMaps
import GoogleMapsUtils

final class MapViewController: UIViewController {
    
    private struct Constants {
        static let searchBarHeight: CGFloat = 68
        static let detailsHeight: CGFloat = 120
        static let markerPadding: CGFloat = 20
    }
    
    let presenter: MapPresenterProtocol
    let markerFactory: MapMarkerFactoryProtocol
    let style: MagellanStyleProtocol
    
    var preferredContentHeight: CGFloat = 0
    var observable = ViewModelObserverContainer<ContainableObserver>()
    
    private var markers: [PlaceViewModel] = []
    private var camera: GMSCameraPosition!
    private var clusterManager: GMUClusterManager!
    
    
    private var myPlaceButton = RoundedButton()
    private var filterButton = RoundedButton()
    private var filterTopConstraint: NSLayoutConstraint?
    private var positionButton = UIButton()
    
    var mapView: GMSMapView {
        return view as! GMSMapView
    }
    
    init(presenter: MapPresenterProtocol,
         markerFactory: MapMarkerFactoryProtocol,
         style: MagellanStyleProtocol) {
        self.presenter = presenter
        self.markerFactory = markerFactory
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        var mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        let position = presenter.position
        camera = GMSCameraPosition.camera(withLatitude: position.lat, longitude: position.lon, zoom: 12.0)
        mapView.camera = camera
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        
        presenter.load()
                
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        observable.observers.forEach {
            $0.observer?.willChangePreferredContentHeight()
        }
        
        var heightDiff: CGFloat = 0.0
        if let origin = view.superview?.convert(view.frame.origin, to: nil) {
            heightDiff = origin.y
        }
        
        if #available(iOS 11.0, *) {
            preferredContentHeight = view.frame.height - view.safeAreaInsets.bottom - MapConstants.listCompactHeight - heightDiff
        } else {
            preferredContentHeight = view.frame.height - MapConstants.listCompactHeight - heightDiff
        }
        
         if let filterTopConstraint = filterTopConstraint,
            filterTopConstraint.constant != preferredContentHeight - 20 {
            filterTopConstraint.constant = preferredContentHeight - 20
            filterTopConstraint.isActive = true
        }
        
        observable.observers.forEach {
            $0.observer?.didChangePreferredContentHeight(to: preferredContentHeight)
        }
    }
    
    private func setupButtons() {
        let side = style.roundedButtonSideSize
        
        guard let filterImage = UIImage(named: "filter", in: Bundle.frameworkBundle, compatibleWith: nil),
            let myPlaceImage = UIImage(named: "gps_locate_me", in: Bundle.frameworkBundle, compatibleWith: nil) else {
                fatalError("Can not load images from fraimwork bundle")
        }
        
        filterButton.imageWithTitleView?.iconImage = filterImage
        filterButton.imageWithTitleView?.spacingBetweenLabelAndIcon = 0
        filterButton.roundedBackgroundView?.cornerRadius = side / 2
        filterButton.roundedBackgroundView?.shadowOpacity = 0.36
        filterButton.roundedBackgroundView?.shadowOffset = CGSize(width: 0, height: 2)
        
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        filterTopConstraint = filterButton.topAnchor.constraint(equalTo: view.topAnchor)
        filterButton.addTarget(nil, action: #selector(tapFilter), for: .touchUpInside)
        
        
        myPlaceButton.imageWithTitleView?.iconImage = myPlaceImage
        myPlaceButton.imageWithTitleView?.spacingBetweenLabelAndIcon = 0
        myPlaceButton.roundedBackgroundView?.cornerRadius = side / 2
        myPlaceButton.roundedBackgroundView?.shadowOpacity = 0.36
        myPlaceButton.roundedBackgroundView?.shadowOffset = CGSize(width: 0, height: 2)
        
        view.addSubview(myPlaceButton)
        myPlaceButton.translatesAutoresizingMaskIntoConstraints = false
        myPlaceButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        myPlaceButton.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor).isActive = true
        myPlaceButton.addTarget(nil, action: #selector(showMyPosition), for: .touchUpInside)
    }
    
    @objc
    private func tapFilter() {
        presenter.showFilter()
    }
    
    @objc
    private func showMyPosition() {
        guard let myLocation = presenter.myLocation else {
            return
        }

        var cameraUpdate = GMSCameraUpdate.setTarget(myLocation.coreLocationCoordinates, zoom: 12)
        mapView.moveCamera(cameraUpdate)
    }
}

extension MapViewController: GMUClusterManagerDelegate {
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        
        return true
    }
    
}


extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let place = marker.userData as? PlaceViewModel else {
            return false
        }
        
        presenter.showDetails(place: place)
        return true
    }
    
}


extension MapViewController: GMUClusterRendererDelegate {
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        guard let place = object as? PlaceViewModel else {
            return nil
        }
        
        return markerFactory.marker(for: place)
    }
    
}

extension MapViewController: MapViewProtocol {
    
    func reloadData() {
        if !isViewLoaded {
            return
        }
        mapView.clear()
        markers = presenter.places
        clusterManager.clearItems()
        clusterManager.add(markers)
        clusterManager.cluster()
        
        if let firstLocation = markers.first?.coordinates {
            var bounds = GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)
            markers.forEach { bounds = bounds.includingCoordinate($0.coordinates) }
            set(bounds: bounds)
        }
    }
    
    func set(bounds: GMSCoordinateBounds) {
        if !isViewLoaded {
            return
        }
        
        var heightDiff: CGFloat = 0.0
        if let origin = view.superview?.convert(view.frame.origin, to: nil) {
            heightDiff = origin.y
        }
        
        let bottomPadding =  MapConstants.listCompactHeight + heightDiff + Constants.markerPadding
        mapView.moveCamera(GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: Constants.markerPadding,
                                                                          left: Constants.markerPadding,
                                                                          bottom: bottomPadding,
                                                                          right: Constants.markerPadding)))
    }
    
    func show(place: PlaceViewModel) {
        if !isViewLoaded {
            return
        }
        let camera = GMSCameraUpdate.setTarget(place.coordinates, zoom: 18)
        mapView.moveCamera(camera)
    }
}

extension MapViewController: Containable {
    var contentView: UIView {
        return view
    }
    
    var contentInsets: UIEdgeInsets {
        return .zero
    }
    
    func setContentInsets(_ contentInsets: UIEdgeInsets, animated: Bool) {}
}
