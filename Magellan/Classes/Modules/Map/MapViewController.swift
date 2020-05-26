//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import SoraUI
import GoogleMaps

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
    
    private var camera: GMSCameraPosition!
    
    
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
        camera = GMSCameraPosition.camera(withLatitude: position.lat, longitude: position.lon, zoom: 8.0)
        mapView.camera = camera
        mapView.delegate = self
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(positionDidChange),
                                               object: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.loadCategories()
    }
    
    private func setupButtons() {
        let side = style.roundedButtonSideSize
        
        guard let filterImage = UIImage(named: "filter", in: Bundle.frameworkBundle, compatibleWith: nil),
            let myPlaceImage = UIImage(named: "gps_locate_me", in: Bundle.frameworkBundle, compatibleWith: nil) else {
                fatalError("Can not load images from fraimwork bundle")
        }
        
        let setupClosure: (RoundedButton) -> Void = { item in
            item.roundedBackgroundView?.cornerRadius = side / 2
            item.roundedBackgroundView?.shadowOpacity = 0.36
            item.roundedBackgroundView?.shadowOffset = CGSize(width: 0, height: 2)
            item.roundedBackgroundView?.fillColor = .white
            item.roundedBackgroundView?.highlightedFillColor = .white
            item.changesContentOpacityWhenHighlighted = true
        }
        
        filterButton.imageWithTitleView?.iconImage = filterImage
        filterButton.isHidden = true
        setupClosure(filterButton)
        
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        filterTopConstraint = filterButton.topAnchor.constraint(equalTo: view.topAnchor)
        filterButton.addTarget(nil, action: #selector(tapFilter), for: .touchUpInside)
        
        
        myPlaceButton.imageWithTitleView?.iconImage = myPlaceImage
        setupClosure(myPlaceButton)
        
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

        var cameraUpdate = GMSCameraUpdate.setTarget(myLocation.coreLocationCoordinates, zoom: 9)
        mapView.moveCamera(cameraUpdate)
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
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(positionDidChange), object: nil)
        perform(#selector(positionDidChange), with: nil, afterDelay: 3.0, inModes: [.common])
    }
    
    @objc
    func positionDidChange() {
        let region = mapView.projection.visibleRegion()
        let zoom = Int(mapView.camera.zoom)
        presenter.loadPlaces(topLeft: region.farLeft.coordinates,
                             bottomRight: region.nearRight.coordinates,
                             zoom: zoom)
    }
    
}

extension MapViewController: MapViewProtocol {
    
    func setFilterButton(hidden: Bool) {
        UIView.animate(withDuration: MapConstants.contentAnimationDuration) {
            self.filterButton.isHidden = hidden
        }
    }
    
    func reloadData() {
        if !isViewLoaded {
            return
        }
        mapView.clear()
        
        presenter.places.forEach {
            self.markerFactory.marker(place: $0).map = self.mapView
        }
        
        presenter.clusters.forEach {
            self.markerFactory.marker(cluster: $0).map = self.mapView
        }
    }
    
    func show(place: PlaceViewModel) {
        if !isViewLoaded {
            return
        }
        let camera = GMSCameraUpdate.setTarget(place.coordinates.coreLocationCoordinates, zoom: 12)
        mapView.moveCamera(camera)
    }
    
    func set(isLoading: Bool) {
        // todo: show loading indicator
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
