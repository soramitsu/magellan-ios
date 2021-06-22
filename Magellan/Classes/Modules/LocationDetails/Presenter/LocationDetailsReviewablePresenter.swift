//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol ReviewsPresenterProtocol: AnyObject {
    
    func loadAllReviews()
}

protocol LocationDetailsDecorable: LocationDetailsPresenterProtocol {
            
    func setItems(_ items: [LocationSectionViewModel])
    
    func setupContent()
}

final class LocationDetailsReviewablePresenter {

    weak var view: LocationDetailsViewProtocol?
    let decorated: LocationDetailsDecorable
    let service: MagellanServicePrototcol
    let localizator: LocalizedResourcesFactoryProtocol
    let place: PlaceInfo
    let dataSource: PlaceReviewDataSource

    internal init(place: PlaceInfo,
                  decorated: LocationDetailsDecorable,
                  service: MagellanServicePrototcol,
                  localizator: LocalizedResourcesFactoryProtocol,
                  dataSource: PlaceReviewDataSource) {
        self.place = place
        self.decorated = decorated
        self.service = service
        self.localizator = localizator
        self.dataSource = dataSource
    }
    
    func becomeObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizationChanged),
                                               name: .init(rawValue: localizator.notificationName),
                                               object: nil)
    }
    
    @objc func localizationChanged() {
        setupContent()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupContent() {
        decorated.setupContent()
        
        var decoratedItems = decorated.items
        let items = dataSource.apply(place).map {
            LocationSectionViewModel(title: nil, header: $0, items: $0.items)
        }
        decoratedItems.append(contentsOf: items)
        decorated.setItems(decoratedItems)
        
        view?.reload()
    }
    
}
extension LocationDetailsReviewablePresenter: ReviewsPresenterProtocol {
    
    func loadAllReviews() {
        service.getAllReviews(with: place.id, runCompletionIn: .main) { [weak self] result in
            result.mapError { (error: Error) -> Error in
                return error
            }.map {
                
                var decoratedItems = self?.decorated.items
                decoratedItems?.removeAll { $0.header != nil }
                
                let items = self?.dataSource.appendAllReviews($0).map {
                    LocationSectionViewModel(title: nil, header: $0, items: $0.items)
                }
                items.map {
                    decoratedItems?.append(contentsOf: $0)
                }
                
                decoratedItems.map { items in
                    self?.decorated.setItems(Array(items))
                    self?.view?.reload()
                }
                
            }
        }
    }

}

extension LocationDetailsReviewablePresenter: LocationDetailsPresenterProtocol {
    
    var delegate: LocationDetailsPresenterDelegate? {
        get { decorated.delegate }
        set { decorated.delegate = newValue }
    }
    var items: [LocationSectionViewModel] { decorated.items }
    
    func dismiss() {
        decorated.dismiss()
    }
    
    func viewDidLoad() {
        setupContent()
    }
}
