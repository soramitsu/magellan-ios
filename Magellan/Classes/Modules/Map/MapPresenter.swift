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
    
    private weak var getPlacesOperation: Operation?
    private var currentSearchText: String?
    
    private(set) var categories: [PlaceCategory] = [] {
        didSet {
            whiteFilter = Set(categories)
        }
    }
    private(set) var whiteFilter: Set<PlaceCategory> = [] {
        didSet {
            if oldValue.count != 0 {
                loadPlaces(search: currentSearchText)
            }
        }
    }
    
    private(set) var places: [PlaceViewModel] = [] {
        didSet {
            view?.reloadData()
            output?.didUpdate(places: places)
        }
    }
    
    private let defaultPosition: Coordinates
    var coordinatesHash: String {
        if let currentPosition = locationService.currentLocation {
            return Geoflash.hash(latitude: currentPosition.lat,
                                 longitude: currentPosition.lon,
                                 precision: 5)
        }
        return Geoflash.hash(latitude: position.lat,
                             longitude: position.lon,
                             precision: 12)
    }
    
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
         defaultPosition: Coordinates) {
        self.service = service
        self.locationService = locationService
        self.defaultPosition = defaultPosition
    }
    
    func load() {
        view?.showLoading()
        
        
        let placeRequest = PlacesRequest(topLeft: coordinatesHash, bottomRight: coordinatesHash, search: nil, categories: [])
        service.getCategoriesAndPlaces(with: placeRequest,
                                       runCompletionIn: DispatchQueue.main) { [weak self] result in
                                        guard let self = self else {
                                            return
                                        }
                                        switch result {
                                        case .success(let tuple):
                                            self.categories = tuple.0
                                            self.places = tuple.1.locations.compactMap { PlaceViewModel(place: $0) }
                                        default:
                                            self.output?.loadingComplete(with: MapError.loadingError, retryClosure: { [weak self] in
                                                self?.load()
                                            })
                                        }
                                        self.view?.hideLoading()
        }

    }
    
    func loadPlaces(search: String?) {
        guard let view = view else {
            return
        }
        currentSearchText = search
        
        view.showLoading()
        let placeRequest = PlacesRequest(topLeft: coordinatesHash, bottomRight: coordinatesHash, search: search, categories: whiteFilter.flatMap{ $0.name } )
        getPlacesOperation?.cancel()
        getPlacesOperation = service.getPlaces(with: placeRequest, runCompletionIn: DispatchQueue.main) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .failure(let error):
                self?.output?.loadingComplete(with: error) { [weak self] in
                    self?.loadPlaces(search: search)
                }
            case .success(let response):
                self?.places = response.locations.flatMap({PlaceViewModel(place: $0)})
            }
        }
    }
    
    func showDetails(place: PlaceViewModel) {
        view?.showLoading()
        service.getPlace(with: place.id, runCompletionIn: DispatchQueue.main) { [weak self] result in
            guard let self = self else {
                return
            }
            self.view?.hideLoading()
            switch result {
            case .success(let info):
                self.view?.show(place: place)
                self.coordinator?.showDetails(for: info)
            case .failure(let error):
                self.output?.loadingComplete(with: error) { [weak self] in
                    self?.showDetails(place: place)
                }
            }
        }
    }
    
    func loadPlaces() {
        loadPlaces(search: nil)
    }
    
    func showFilter() {
        coordinator?.showCategoriesFilter(categories: categories, filter: whiteFilter, output: self)
    }
}

extension MapPresenter: MapListOutputProtocol {
    
    func select(place: PlaceViewModel) {
        showDetails(place: place)
    }
    
    func search(with text: String) {
        loadPlaces(search: text)
    }
    
    func reset() {
        loadPlaces()
    }

}

extension MapPresenter: UserLocationServiceDelegate {
    func userLocationDidUpdate() {
        loadPlaces(search: currentSearchText)
    }
}

extension MapPresenter: CategoriesFilterOutputProtocol {
    func categoriesFilter(_ filter: Set<PlaceCategory>) {
        whiteFilter = filter
    }
}
