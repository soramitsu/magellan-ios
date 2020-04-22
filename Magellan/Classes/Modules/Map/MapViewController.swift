//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
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
    
    var preferredContentHeight: CGFloat = 0
    var observable = ViewModelObserverContainer<ContainableObserver>()
    
    private var markers: [PlaceViewModel] = []
    private var camera: GMSCameraPosition!
    private var clusterManager: GMUClusterManager!
    
    var mapView: GMSMapView {
        return view as! GMSMapView
    }
    
    init(presenter: MapPresenterProtocol,
         markerFactory: MapMarkerFactoryProtocol) {
        self.presenter = presenter
        self.markerFactory = markerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        var mapView = GMSMapView()
        camera = GMSCameraPosition.camera(withLatitude: 11.5796669, longitude: 104.7501013, zoom: 12.0)
        mapView.camera = camera
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let projection = mapView.projection.visibleRegion()
        let topLeft = Coordinates(lat: projection.farLeft.latitude, lon: projection.farLeft.longitude)
        let bottomRight = Coordinates(lat: projection.nearRight.latitude, lon: projection.nearRight.longitude)
        // TODO: find out what is it zoom
        presenter.loadPlaces()
                
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
        
        preferredContentHeight = view.frame.height - MapConstants.listCompactHeight - heightDiff
        
        observable.observers.forEach {
            $0.observer?.didChangePreferredContentHeight(to: preferredContentHeight)
        }
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
    
    var zoom: Int {
        return Int(camera.zoom)
    }
    
    var coordinatesHash: String {
        return Geoflash.hash(latitude: camera.target.latitude, longitude: camera.target.longitude)
    }
    
    
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
