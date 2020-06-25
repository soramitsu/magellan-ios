//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListPresenter: MapListPresenterProtocol {

    var places: [PlaceViewModel] = []
    let localizator: LocalizedResourcesFactoryProtocol
    
    weak var view: MapListViewProtocol?
    weak var delegate: MapListPresenterDelegate?
    weak var output: MapListOutputProtocol?
    private var state: MapListModuleState = .normal {
        didSet {
            output?.moduleChange(state: state)
        }
    }
    
    init(localizator: LocalizedResourcesFactoryProtocol) {
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
    
    func search(with text: String?) {
        
        output?.search(with: text)
    }
    
    func dismiss() {
        delegate?.collapseList()
    }
    
    func expand() {
        state = .search
        delegate?.expandList()
    }
    
    func viewDidLoad() {
        view?.set(placeholder: localizator.searchPlaceholder)
    }
    
    func finishSearch() {
        if state == .error {
            return
        }
        state = .normal
    }
}

extension MapListPresenter: MapOutputProtocol {
    
    func loading(_ show: Bool) {
        view?.set(loading: show)
    }
    
    func didUpdate(places: [PlaceViewModel]) {
        if state == .error {
            return
        }
        self.places = places
        view?.reloadPlaces()
    }
    
    func loadingComplete(with error: Error?, retryClosure: @escaping () -> Void) {
        state = .error
        delegate?.collapseList()
        view?.showErrorState() {
            self.state = .normal
            retryClosure()
        }
    }
}
