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
    
    weak var mapInput: MapInputProtocol?
    
    func showDetails(place: PlaceViewModel) {
        mapInput?.select(place: place)
    }
    
    func select(category: String) {
        mapInput?.select(category: category)
    }
    
    func search(with text: String) {
        mapInput?.search(with: text)
    }
    
    
}

extension MapListPresenter: MapListInputProtocol {
    func set(categories: [PlaceCategory], places: [PlaceViewModel]) {
        self.categories = categories
        self.places = places
        view?.reloadData()
    }
}
