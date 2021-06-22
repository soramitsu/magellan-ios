//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol MapPresenterDecorable: MapPresenterProtocol {
    
    var logger: LoggerDecorator? { get }
    var alertHelper: AlertHelperProtocol? { get }
    
    func setSelectedPlace(_ place: PlaceViewModel)
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


