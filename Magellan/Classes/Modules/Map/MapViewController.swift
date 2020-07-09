//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import SoraUI
import GoogleMaps

final class MapViewController: UIViewController {
    
    private enum State {
        case normal
        case cluster
    }
    
    private struct Constants {
        static let searchBarHeight: CGFloat = 68
        static let detailsHeight: CGFloat = 120
        static let markerPadding: CGFloat = 20
        static let defaultZoom: Float = 12
    }
    
    let presenter: MapPresenterProtocol
    let markerFactory: MapMarkerFactoryProtocol
    let style: MagellanStyleProtocol
    
    var preferredContentHeight: CGFloat = 0 {
        willSet {
            if preferredContentHeight == newValue {
                return
            }
            observable.observers.forEach {
                $0.observer?.willChangePreferredContentHeight()
            }
        }
        
        didSet {
            if preferredContentHeight == oldValue {
                return
            }
            observable.observers.forEach {
                $0.observer?.didChangePreferredContentHeight(to: preferredContentHeight)
            }
        }
    }
    var observable = ViewModelObserverContainer<ContainableObserver>()
    
    private var camera: GMSCameraPosition!
    private weak var selectedMarker: GMSMarker?
    
    private var myPlaceButton: RoundedButton!
    private var filterButton: RoundedButton!
    private var positionButton = UIButton()
    private var state: State = .normal
    private var placeMarkers: [GMSMarker] = []
    
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
        
        if preferredContentHeight != 0 {
            return
        }
        
        myPlaceButton.frame.origin.x = view.frame.width - myPlaceButton.bounds.size.width - 10
        
        var heightDiff: CGFloat = 0.0
        if let origin = view.superview?.convert(view.frame.origin, to: nil) {
            heightDiff = origin.y
        }
        
        if #available(iOS 11.0, *) {
            preferredContentHeight = view.frame.height - view.safeAreaInsets.bottom - MapConstants.listCompactHeight - heightDiff
        } else {
            preferredContentHeight = view.frame.height - MapConstants.listCompactHeight - heightDiff
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.loadCategories()
        positionDidChange()
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
        
        filterButton = RoundedButton(frame: CGRect(x: 10, y: 0, width: 32, height: 32))
        filterButton.imageWithTitleView?.iconImage = filterImage
        filterButton.isHidden = true
        setupClosure(filterButton)
        
        view.addSubview(filterButton)
        filterButton.addTarget(nil, action: #selector(tapFilter), for: .touchUpInside)
        
        myPlaceButton = RoundedButton(frame: CGRect(x: view.frame.width - 10, y: 0, width: 32, height: 32))
        myPlaceButton.imageWithTitleView?.iconImage = myPlaceImage
        setupClosure(myPlaceButton)
        
        view.addSubview(myPlaceButton)
        myPlaceButton.addTarget(nil, action: #selector(showMyPosition), for: .touchUpInside)
    }
    
    @objc
    private func tapFilter() {
        presenter.removeSelection()
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
        if selectedMarker == marker {
            return true
        }
        
        if let animatable = selectedMarker?.iconView as? Selectable {
            animatable.setSelected(false, animated: true)
        }
        
        if let place = marker.userData as? PlaceViewModel {
            removeSelection()
            presenter.showDetails(place: place)
            return true
        }
        
        if let cluster = marker.userData as? ClusterViewModel {
            let cameraUpdate = GMSCameraUpdate.setTarget(cluster.coordinates.coreLocationCoordinates,
                                                         zoom: mapView.camera.zoom + 1)
            state = .cluster
            mapView.animate(with: cameraUpdate)
            return true
        }
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(positionDidChange), object: nil)
        switch state {
        case .normal:
            break
        case .cluster:
            presenter.mapCameraDidChange()
            positionDidChange()
            state = .normal
            return
        }
        presenter.mapCameraDidChange()
        perform(#selector(positionDidChange), with: nil, afterDelay: presenter.requestDelay, inModes: [.common])
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
    
    func updateSelection() {
        removeSelection()
        guard let selectedPlace = presenter.selectedPlace else {
            return
        }
        
        let marker = placeMarkers.first(where: { ($0.userData as? PlaceViewModel)?.id == selectedPlace.id })
        (marker?.iconView as? Selectable)?.setSelected(true, animated: true)
        selectedMarker = marker
    }
    
    func removeSelection() {
        (selectedMarker?.iconView as? Selectable)?.setSelected(false, animated: true)
        selectedMarker = nil
    }
    
    func setFilterButton(hidden: Bool) {
        UIView.animate(withDuration: MapConstants.contentAnimationDuration) {
            self.filterButton.isHidden = hidden
        }
    }
    
    func reloadData() {
        if !isViewLoaded {
            return
        }
        let selectedPlace = presenter.selectedPlace
        mapView.clear()
        
        var markers: [GMSMarker] = []
        presenter.places.forEach {
            let isSelected = $0.id == selectedPlace?.id
            let item = self.markerFactory.marker(place: $0, selected: isSelected)
            item.map = self.mapView
            markers.append(item)
            if isSelected {
                self.selectedMarker = item
            }
        }
        placeMarkers = markers
        
        presenter.clusters.forEach {
            self.markerFactory.marker(cluster: $0, font: style.semiBold10).map = self.mapView
        }
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
    
    func draggable(_ draggable: Draggable, didChange frame: CGRect) {
        let newYOrigin = frame.origin.y - filterButton.bounds.height - 20
        if newYOrigin < view.center.y / 2
        || filterButton.frame.origin.y == newYOrigin {
            return
        }
        filterButton.frame = rect(for: filterButton, with: newYOrigin)
        myPlaceButton.frame = rect(for: myPlaceButton, with: newYOrigin)
    }
    
    private func rect(for item: UIView, with yOrigin: CGFloat) -> CGRect {
        return CGRect(x: item.frame.origin.x,
                      y: yOrigin,
                      width: item.bounds.width,
                      height: item.bounds.height)
    }
}
