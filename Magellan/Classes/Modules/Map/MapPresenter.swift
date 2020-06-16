//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

enum MapError: Error {
    case loadingError
}

final class MapPresenter: MapPresenterProtocol {
    
    weak var view: MapViewProtocol?
    weak var coordinator: MapCoordinatorProtocol?
    weak var output: MapOutputProtocol?
    var service: MagellanServicePrototcol
    private var locationService: UserLocationServiceProtocol
    private let localizator: LocalizedResourcesFactoryProtocol
    
    private weak var getPlacesOperation: Operation?
    var currentSearchText: String?
    var currentTopLeft: Coordinates?
    var currentBottomRight: Coordinates?
    var currentZoom: Int?
    
    private(set) var categories: [PlaceCategory] = [] {
        didSet {
            whiteFilter = Set(categories)
        }
    }
    private(set) var whiteFilter: Set<PlaceCategory> = [] {
        didSet {
            if oldValue.count != 0 {
                reloadIfNeeded(search: currentSearchText)
            }
        }
    }
    
    private(set) var places: [PlaceViewModel] = [] {
        didSet {
            output?.didUpdate(places: places)
        }
    }
    private(set) var clusters: [ClusterViewModel] = []
    
    private let defaultPosition: Coordinates

    
    var position: Coordinates {
        if let currentPosition = locationService.currentLocation {
            return currentPosition
        }
        return defaultPosition
    }
    
    var myLocation: Coordinates? {
        return locationService.currentLocation
    }
    
    init(service: MagellanServicePrototcol,
         locationService: UserLocationServiceProtocol,
         defaultPosition: Coordinates,
         localizator: LocalizedResourcesFactoryProtocol) {
        self.service = service
        self.locationService = locationService
        self.defaultPosition = defaultPosition
        self.localizator = localizator
    }
    
    func loadCategories() {
        if !categories.isEmpty {
            return
        }
        
        view?.setFilterButton(hidden: true)
        service.getCategories(runCompletionIn: DispatchQueue.main) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let items):
                self.categories = items
                self.view?.setFilterButton(hidden: false)
            default:
                self.output?.loadingComplete(with: MapError.loadingError, retryClosure: { [weak self] in
                    self?.loadCategories()
                    self?.reloadIfNeeded(search: self?.currentSearchText)
                })
            }
        }
    }
    
    func loadPlaces(topLeft: Coordinates, bottomRight: Coordinates, zoom: Int) {
        loadPlaces(topLeft: topLeft, bottomRight: bottomRight, zoom: zoom, search: currentSearchText)
    }
    
    func loadPlaces(topLeft: Coordinates, bottomRight: Coordinates, zoom: Int, search: String?) {
        guard let view = view else {
            return
        }
        currentSearchText = search
        
        let placeRequest = PlacesRequest(topLeft: topLeft,
                                         bottomRight: bottomRight,
                                         search: search,
                                         categories: whiteFilter.flatMap{ $0.name },
                                         zoom: zoom )
        getPlacesOperation?.cancel()
        getPlacesOperation = service.getPlaces(with: placeRequest, runCompletionIn: DispatchQueue.main) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.output?.loadingComplete(with: error) { [weak self] in
                    self?.loadCategories()
                    self?.loadPlaces(topLeft: topLeft, bottomRight: bottomRight, zoom: zoom, search: search)
                }
            case .success(let response):
                self.places = response.locations.compactMap { PlaceViewModel(place: $0, locale: self.localizator.locale) }
                self.clusters = response.clusters.compactMap { ClusterViewModel(cluster: $0) }
                self.view?.reloadData()
            }
        }
        
        currentZoom = zoom
        currentTopLeft = topLeft
        currentBottomRight = bottomRight
    }
    
    func showDetails(place: PlaceViewModel, showOnMap: Bool) {
        view?.showLoading()
        service.getPlace(with: place.id, runCompletionIn: DispatchQueue.main) { [weak self] result in
            guard let self = self else {
                return
            }
            self.view?.hideLoading()
            switch result {
            case .success(let info):
                if showOnMap {
                    self.view?.show(place: place)
                }
                self.coordinator?.showDetails(for: info)
            case .failure(let error):
                self.output?.loadingComplete(with: error) { [weak self] in
                    self?.showDetails(place: place, showOnMap: showOnMap)
                }
            }
        }
    }
    
    func reloadIfNeeded(search: String?) {
        guard let currentTopLeft = currentTopLeft,
            let currentBottomRight = currentBottomRight,
            let currentZoom = currentZoom else {
                return
        }
        loadPlaces(topLeft: currentTopLeft, bottomRight: currentBottomRight, zoom: currentZoom, search: search)
    }
    
    
    
    func showFilter() {
        coordinator?.showCategoriesFilter(categories: categories, filter: whiteFilter, output: self)
    }
}

extension MapPresenter: MapListOutputProtocol {
    
    func select(place: PlaceViewModel) {
        showDetails(place: place, showOnMap: true)
    }
    
    func search(with text: String?) {
        if text?.count == 1 {
            return
        }
        reloadIfNeeded(search: text?.isEmpty == true ? nil : text)
    }
    
    func reset() {
        reloadIfNeeded(search: nil)
    }

}

extension MapPresenter: UserLocationServiceDelegate {
    func userLocationDidUpdate() {
        reloadIfNeeded(search: currentSearchText)
    }
}

extension MapPresenter: CategoriesFilterOutputProtocol {
    func categoriesFilter(_ filter: Set<PlaceCategory>) {
        whiteFilter = filter
    }
}
