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
    private var zoomInButton: RoundedButton!
    private var zoomOutButton: RoundedButton!
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
        setupConstraints()
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
        let viewHeight = view.frame.height
        
        guard let filterImage = UIImage(named: "map_filter", in: Bundle.frameworkBundle, compatibleWith: nil),
            let myPlaceImage = UIImage(named: "map_location", in: Bundle.frameworkBundle, compatibleWith: nil),
            let plusImage = UIImage(named: "map_plus", in: Bundle.frameworkBundle, compatibleWith: nil),
            let minusImage = UIImage(named: "map_minus", in: Bundle.frameworkBundle, compatibleWith: nil) else {
                fatalError("Can not load images from fraimwork bundle")
        }
        
        filterButton = RoundedButton(frame: CGRect(x: 0, y: 0, width: side, height: side))
        filterButton.imageWithTitleView?.iconImage = filterImage
        filterButton.isHidden = true
        filterButton.addTarget(nil, action: #selector(tapFilter), for: .touchUpInside)
        filterButton.configureRound(with: side)
        view.addSubview(filterButton)

        myPlaceButton = RoundedButton(frame: CGRect(x: 0, y: 0, width: side, height: side))
        myPlaceButton.imageWithTitleView?.iconImage = myPlaceImage
        myPlaceButton.addTarget(nil, action: #selector(showMyPosition), for: .touchUpInside)
        myPlaceButton.configureRound(with: side)
        view.addSubview(myPlaceButton)

        zoomInButton = RoundedButton(frame: CGRect(x: 0, y: 0, width: side, height: side))
        zoomInButton.imageWithTitleView?.iconImage = plusImage
        zoomInButton.addTarget(self, action: #selector(zoomInHandler(sender:)), for: .touchUpInside)
        zoomInButton.configureRound(with: side)
        view.addSubview(zoomInButton)

        zoomOutButton = RoundedButton(frame: CGRect(x: 0, y: 0, width: side, height: side))
        zoomOutButton.imageWithTitleView?.iconImage = minusImage
        zoomOutButton.addTarget(self, action: #selector(zoomOutHandler(sender:)), for: .touchUpInside)
        zoomOutButton.configureRound(with: side)
        view.addSubview(zoomOutButton)
    }

    private func setupConstraints() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.leftAnchor.constraint(equalTo: view.leftAnchor,
                                           constant: style.doubleOffset).isActive = true

        if #available(iOS 11.0, *) {
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -118).isActive = true
        } else {
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                 constant: -118).isActive = true
        }

        myPlaceButton.translatesAutoresizingMaskIntoConstraints = false
        myPlaceButton.rightAnchor.constraint(equalTo: view.rightAnchor,
                                             constant: -style.doubleOffset).isActive = true
        myPlaceButton.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor).isActive = true

        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomInButton.centerXAnchor.constraint(equalTo: myPlaceButton.centerXAnchor).isActive = true
        zoomInButton.bottomAnchor.constraint(equalTo: zoomOutButton.topAnchor, constant: -12).isActive = true

        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.centerXAnchor.constraint(equalTo: myPlaceButton.centerXAnchor).isActive = true
        zoomOutButton.bottomAnchor.constraint(equalTo: myPlaceButton.topAnchor, constant: -40).isActive = true
    }

    @objc
    private func zoomInHandler(sender: Any) {
        mapView.animate(toZoom: mapView.camera.zoom + 1)
    }

    @objc
    private func zoomOutHandler(sender: Any) {
        mapView.animate(toZoom: mapView.camera.zoom - 1)
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

    func setButtons(hidden: Bool) {
        UIView.animate(withDuration: MapConstants.contentAnimationDuration) {
            self.filterButton.isHidden = hidden
            self.positionButton.isHidden = hidden
            self.zoomInButton.isHidden = hidden
            self.zoomOutButton.isHidden = hidden
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
    
    func draggable(_ draggable: Draggable, didChange frame: CGRect) { }
}
