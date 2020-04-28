//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapPresenter: MapPresenterProtocol {
    
    var alertManager: AlertManagerProtocol?
    var defaultAlertMessage: MessageProtocol?
    var view: MapViewProtocol?
    weak var coordinator: MapCoordinatorProtocol?
    weak var output: MapOutputProtocol?
    var service: MagellanServicePrototcol
    private var locationService: UserLocationServiceProtocol
    
    private weak var getPlacesOperation: Operation?
    private var currentCategory: String?
    private var currentSearchText: String?
    
    private(set) var categories: [PlaceCategory] = [] {
        didSet {
            output?.didUpdate(categories: categories)
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
                                 precision: 12)
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
    
    init(service: MagellanServicePrototcol,
         locationService: UserLocationServiceProtocol,
         defaultPosition: Coordinates) {
        self.service = service
        self.locationService = locationService
        self.defaultPosition = defaultPosition
    }
    
    func loadCategories() {
        view?.showLoading()
        service.getCategories(runCompletionIn: DispatchQueue.main) { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.locationService.delegaet = self
                self?.loadPlaces()
            case .failure(let error):
                self?.view?.hideLoading()
                self?.categories = []
                self?.tryShowDefaultAlert {
                    self?.loadCategories()
                }
            }
        }
    }
    
    func loadPlaces(category: String?,
                    search: String?) {
        guard let view = view else {
            return
        }
        currentCategory = category
        currentSearchText = search
        
        view.showLoading()
        let placeRequest = PlacesRequest(location: coordinatesHash,
                                         search: search,
                                         category: category)
        getPlacesOperation?.cancel()
        getPlacesOperation = service.getPlaces(with: placeRequest, runCompletionIn: DispatchQueue.main) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .failure(let error):
                self?.tryShowDefaultAlert {
                    self?.loadPlaces(category: category, search: search)
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
                self.tryShowDefaultAlert { [weak self] in
                    self?.showDetails(place: place)
                }
            }
        }
    }
    
    func loadPlaces() {
        loadPlaces(category: nil, search: nil)
    }
    
    private func tryShowDefaultAlert(retryAction: @escaping () -> Void) {
        guard let alertManager = alertManager,
            let controller = view?.controller else {
            return
        }
        alertManager.showAlert(viewController: controller,
                               title: defaultAlertMessage?.title ?? L10n.Error.Default.title,
                               message: defaultAlertMessage?.message ?? L10n.Error.Default.message,
                               actions: [(L10n.cancel, .cancel), (L10n.retry, .default)]) { number in
                                if number == 1 {
                                    retryAction()
                                }
        }
    }
}

extension MapPresenter: MapListOutputProtocol {
    
    func select(place: PlaceViewModel) {
        showDetails(place: place)
    }
    
    func select(category: String) {
        loadPlaces(category: category, search: nil)
    }
    
    func search(with text: String) {
        loadPlaces(category: nil, search: text)
    }
    
    func reset() {
        loadPlaces()
    }

}

extension MapPresenter: UserLocationServiceDelegate {
    func userLocationDidUpdate() {
        loadPlaces(category: currentCategory, search: currentSearchText)
    }
}
