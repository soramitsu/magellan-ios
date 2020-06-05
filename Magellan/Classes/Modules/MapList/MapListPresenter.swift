//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListPresenter: MapListPresenterProtocol {
    
    var places: [PlaceViewModel] = []
    let localizator: LocalizedResorcesFactoryProtocol
    
    weak var view: MapListViewProtocol?
    weak var delegate: MapListPresenterDelegate?
    weak var output: MapListOutputProtocol?
    
    init(localizator: LocalizedResorcesFactoryProtocol) {
        self.localizator = localizator
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizationChanged),
                                               name: .init(rawValue: localizator.notificationName),
                                               object: nil)
    }
    
    @objc func localizationChanged() {
        view?.set(placeholder: localizator.searchPlaceholder)
    }
    
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
    
    func viewDidLoad() {
        view?.set(placeholder: localizator.searchPlaceholder)
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
