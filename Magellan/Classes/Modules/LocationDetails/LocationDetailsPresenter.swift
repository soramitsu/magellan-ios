/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import MessageUI
import SafariServices


final class LocationDetailsPresenter {
    
    weak var view: LocationDetailsViewProtocol?
    weak var delegate: LocationDetailsPresenterDelegate?
    let place: PlaceInfo
    private(set) var items: [MapDetailViewModelProtocol] = []

    init(placeInfo: PlaceInfo) {
        place = placeInfo
        setupContent()
    }
    
    func setupContent() {
        if let phone = place.phoneNumber.formattedPhone(region: place.region), !phone.isEmpty {
            let rawPhone = place.phoneNumber
            items.append(MapDetailViewModel(title: L10n.Location.Details.phone,
                                              content: phone,
                                              action: { [weak self] in
                                                self?.handle(path: "tel://\(rawPhone)")
            }))
        }

        if !place.website.isEmpty {
            let website = place.website
            items.append(MapDetailViewModel(title: L10n.Location.Details.website,
                                              content: place.website,
                                              action: { [weak self] in
                                                self?.handle(path: website)
            }))
        }

        if !place.facebook.isEmpty {
            let fb = place.facebook
            items.append(MapDetailViewModel(title: L10n.Location.Details.fb,
                                              content: place.facebook,
                                              action: { [weak self] in
                                                self?.handle(path: fb)
            }))
        }

        if !place.address.isEmpty {
            items.append(MapAddressViewModel(title: L10n.Location.Details.address,
                                               description: place.address))
        }
        

    }
    
    func handle(path: String) {
        guard let view = view else {
            return
        }
        handle(path: path, on: view.controller)
    }
}


extension LocationDetailsPresenter: LocationDetailsPresenterProtocol {
    
    var title: String {
        return place.name
    }
    
    var category: String {
        return place.type
    }
    
    var distance: String {
        return place.distance
    }
    
    var workingStatus: String {
        place.workingStatus
    }
    
    var isOpen: Bool {
        place.isOpen
    }
    
    func dismiss() {
        delegate?.dismiss()
    }
    
}

extension LocationDetailsPresenter: UrlHandlerProtocol { }
