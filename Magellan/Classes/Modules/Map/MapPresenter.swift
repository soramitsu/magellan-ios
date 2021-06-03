//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

enum MapError: Error {
    case loadingError
}

protocol MapPresenterDecorable: MapPresenterProtocol {
    
    var logger: LoggerDecorator? { get }
    var alertHelper: AlertHelperProtocol? { get }
    
    func setSelectedPlace(_ place: PlaceViewModel)
}

extension MapPresenter: MapPresenterDecorable {
    
    func setSelectedPlace(_ place: PlaceViewModel) {
        self.selectedPlace = place
    }
    
}

final class MapReviewablePresenter {
    
    let service: MagellanServicePrototcol
    let decorated: MapPresenterDecorable
    let localizator: LocalizedResourcesFactoryProtocol
    
    internal init(decorated: MapPresenterDecorable,
                  service: MagellanServicePrototcol,
                  localizator: LocalizedResourcesFactoryProtocol) {
        self.decorated = decorated
        self.service = service
        self.localizator = localizator
    }
    
    func showDetails(place: PlaceViewModel) {
        view?.showLoading()
        service.getPlaceSummaryInfo(with: place.id,
                                    runCompletionIn: .main) { [weak self] result in
            self?.logger?.log(result)
            self?.view?.hideLoading()
            result.mapError { (error: Error) -> Error in
                self?.logger?.log(error)
                self?.showErrorAlert { self?.showDetails(place: place) }
                return error
            }.map {
                $0
                self?.coordinator?.showDetails(for: $0)
                self?.decorated.setSelectedPlace(place)
                self?.view?.setButtons(hidden: true)
            }
        }
    }

    private func showErrorAlert(with retry: @escaping () -> Void) {
        alertHelper?.showToast(with: localizator.loadingError,
                               title: localizator.error,
                               action: (title: localizator.retry, action: retry))
    }

}
extension MapReviewablePresenter: MapPresenterProtocol {
    
    var view: MapViewProtocol? {
        get { decorated.view }
        set { decorated.view = newValue }
    }
    
    var coordinator: MapCoordinatorProtocol? {
        get { decorated.coordinator }
        set { decorated.coordinator = newValue }
    }
    
    var output: MapOutputProtocol? {
        get { decorated.output }
        set { decorated.output = newValue }
    }
    
    var categories: [PlaceCategory] { decorated.categories }
    var places: [PlaceViewModel] { decorated.places }
    var clusters: [ClusterViewModel] { decorated.clusters }
    var position: Coordinates { decorated.position }
    var myLocation: Coordinates? { decorated.myLocation }
    var requestDelay: TimeInterval { decorated.requestDelay }
    var selectedPlace: PlaceViewModel? { decorated.selectedPlace }
    var logger: LoggerDecorator? { decorated.logger }
    var alertHelper: AlertHelperProtocol? { decorated.alertHelper }
    
    func loadCategories() {
        decorated.loadCategories()
    }
    
    func loadPlaces(topLeft: Coordinates, bottomRight: Coordinates, zoom: Int) {
        decorated.loadPlaces(topLeft: topLeft, bottomRight: bottomRight, zoom: zoom)
    }
    
    func mapCameraDidChange() {
        decorated.mapCameraDidChange()
    }
    
    func showFilter() {
        decorated.showFilter()
    }
    
    func removeSelection() {
        decorated.removeSelection()
    }
    
    func select(place: PlaceViewModel) {
        showDetails(place: place)
    }
    
    func search(with text: String?) {
        decorated.search(with: text)
    }
    
    func reset() {
        decorated.reset()
    }

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
    private var searchMinimumLettersCount: Int = 2
    private(set)var requestDelay: TimeInterval = 1
    private(set) var selectedPlace: PlaceViewModel? {
        didSet {
            view?.updateSelection()
        }
    }
    
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
            if let selectedPlace = self.selectedPlace,
                !places.contains(selectedPlace) {
                coordinator?.hideDetailsIfPresented()
                self.selectedPlace = nil
            }
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
    
    var logger: LoggerDecorator?
    var alertHelper: AlertHelperProtocol?
    
    init(service: MagellanServicePrototcol,
         locationService: UserLocationServiceProtocol,
         defaultPosition: Coordinates,
         localizator: LocalizedResourcesFactoryProtocol) {
        self.service = service
        self.locationService = locationService
        self.defaultPosition = defaultPosition
        self.localizator = localizator
    }
    
    func set(parameters: MagellanParametersProtocol) {
        self.searchMinimumLettersCount = parameters.searchMinimumLettersCount
        self.requestDelay = parameters.requestDelayOnMapChange
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
            self.logger?.log(result)
            switch result {
            case .success(let items):
                self.categories = items
                self.view?.setFilterButton(hidden: false)
            default:
                self.showErrorAlert { [weak self] in
                    self?.loadCategories()
                }
                return
            }
        }
    }

    private func showErrorAlert(with retry: @escaping () -> Void) {
        alertHelper?.showToast(with: localizator.loadingError,
                               title: localizator.error,
                               action: (title: localizator.retry, action: retry))
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
                                         categories: whiteFilter.flatMap{ $0.id },
                                         zoom: zoom )
        getPlacesOperation?.cancel()
        getPlacesOperation = service.getPlaces(with: placeRequest, runCompletionIn: DispatchQueue.main) { [weak self] result in
            guard let self = self else {
                return
            }
            self.logger?.log(result)
            switch result {
            case .failure(let error):
                self.showErrorAlert { [weak self] in
                    self?.loadPlaces(topLeft: topLeft,
                                     bottomRight: bottomRight,
                                     zoom: zoom,
                                     search: search)
                }
            case .success(let response):
                self.places = response.locations.compactMap { PlaceViewModel(place: $0, locale: self.localizator.locale) }
                self.clusters = response.clusters.compactMap { ClusterViewModel(cluster: $0) }
                self.view?.reloadData()
            }
            self.output?.loading(false)
        }
        
        currentZoom = zoom
        currentTopLeft = topLeft
        currentBottomRight = bottomRight
    }
    
    func showDetails(place: PlaceViewModel) {
        view?.showLoading()
        service.getPlace(with: place.id, runCompletionIn: DispatchQueue.main) { [weak self] result in
            guard let self = self else {
                return
            }
            self.logger?.log(result)
            self.view?.hideLoading()
            switch result {
            case .success(let info):
                self.coordinator?.showDetails(for: info)
                self.selectedPlace = place
                self.view?.setButtons(hidden: true)
            case .failure(let error):
                self.logger?.log(error)
                self.showErrorAlert { [weak self] in
                    self?.showDetails(place: place)
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
        output?.loading(true)
        loadPlaces(topLeft: currentTopLeft, bottomRight: currentBottomRight, zoom: currentZoom, search: search)
    }
    
    func mapCameraDidChange() {
        output?.loading(true)
    }
    
    func showFilter() {
        selectedPlace = nil
        coordinator?.showCategoriesFilter(categories: categories, filter: whiteFilter, output: self)
    }
    func removeSelection() {
        selectedPlace = nil
        view?.setButtons(hidden: false)
        if categories.isEmpty {
            view?.setFilterButton(hidden: true)
        }
    }
}

extension MapPresenter: MapListOutputProtocol {
    
    func select(place: PlaceViewModel) {
        showDetails(place: place)
    }
    
    func search(with text: String?) {
        if let text = text,
            !text.isEmpty,
            text.count < searchMinimumLettersCount {
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
