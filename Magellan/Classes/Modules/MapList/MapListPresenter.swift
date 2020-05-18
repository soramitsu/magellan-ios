//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListPresenter: MapListPresenterProtocol {
    
    var places: [PlaceViewModel] = []
    
    weak var view: MapListViewProtocol?
    weak var delegate: MapListPresenterDelegate?
    weak var output: MapListOutputProtocol?
    
    func showDetails(place: PlaceViewModel) {
        output?.select(place: place)
    }
    
    func search(with text: String) {
        output?.search(with: text)
    }
    
    func dismiss() {
        delegate?.collapseList()
    }
    
    func expand() {
        delegate?.expandList()
    }
}

extension MapListPresenter: MapOutputProtocol {
    func didUpdate(places: [PlaceViewModel]) {
        self.places = places
        view?.reloadPlaces()
    }
    
    func loadingComplete(with error: Error?, retryClosure: @escaping () -> Void) {
        view?.showErrorState(retryClosure)
    }
}
