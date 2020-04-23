/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import CoreLocation

final class DashboardMapPresenter: NSObject, DashboardMapPresenterProtocol {
    
    weak var view: DashboardMapViewProtocol?
    weak var mapView: MapViewProtocol?
    weak var listView: MapListViewProtocol?
    var coordinator: DashboardMapCoordinatorProtocol?
    
    let service: MagellanServicePrototcol
    
    private(set) var categories: [Category] = [] {
        didSet {
            mapView?.reloadData()
            listView?.reloadData()
        }
    }
    private(set) var places: [PlaceViewModel] = [] {
        didSet {
            mapView?.reloadData()
            listView?.reloadData()
        }
    }
    
    init(service: MagellanServicePrototcol) {
        self.service = service
        super.init()
        loadCategories()
    }
    
    func loadCategories() {
        service.getCategories(runCompletionIn: DispatchQueue.main) { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
            case .failure(let error):
                self?.categories = []
                print(error)
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
                self.mapView?.show(place: place)
                self.coordinator?.showDetails(for: info)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadPlaces(category: String?,
                    search: String?) {
        guard let mapView = mapView else {
            return
        }
        
        view?.showLoading()
        let placeRequest = PlacesRequest(location: mapView.coordinatesHash,
                                         zoom: mapView.zoom,
                                         search: search,
                                         category: category)
        service.getPlaces(with: placeRequest, runCompletionIn: DispatchQueue.main) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self?.places = response.locations.flatMap({PlaceViewModel(place: $0)})
            }
        }
    }
}

extension DashboardMapPresenter: MapPresenterProtocol {
    
    func loadPlaces() {
        loadPlaces(category: nil, search: nil)
    }
    
}

extension DashboardMapPresenter: MapListPresenterProtocol {
    func select(category: String) {
        loadPlaces(category: category, search: nil)
    }
    
    func serach(with text: String) {
        loadPlaces(category: nil, search: text)
    }
}
