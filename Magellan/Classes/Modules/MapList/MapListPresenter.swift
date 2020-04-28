//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListPresenter: MapListPresenterProtocol {
    
    var categories: [PlaceCategory] = []
    var places: [PlaceViewModel] = []
    
    var view: MapListViewProtocol?
    
    weak var output: MapListOutputProtocol?
    
    func showDetails(place: PlaceViewModel) {
        output?.select(place: place)
    }
    
    func select(category: String) {
        output?.select(category: category)
    }
    
    func search(with text: String) {
        output?.search(with: text)
    }
    
    
}

extension MapListPresenter: MapOutputProtocol {
    func didUpdate(categories: [PlaceCategory]) {
        self.categories = categories
        view?.reloadCategories()
    }
    
    func didUpdate(places: [PlaceViewModel]) {
        self.places = places
        view?.reloadPlaces()
    }
}
