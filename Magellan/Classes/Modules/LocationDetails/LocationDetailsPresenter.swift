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
    let formatter: PhoneFormatterProtocol?
    private(set) var items: [MapDetailViewModelProtocol] = []

    init(placeInfo: PlaceInfo, phoneFormatter: PhoneFormatterProtocol? = nil) {
        place = placeInfo
        formatter = phoneFormatter
        setupContent()
    }
    
    func setupContent() {
        if !place.phoneNumber.isEmpty {
            let rawPhone = place.phoneNumber
            let phone = formatter?.formattedPhoneNumber(with: rawPhone, region: place.region) ?? rawPhone
            items.append(MapDetailViewModel(type: .phone,
                                            content: phone,
                                            action: { [weak self] in
                                                self?.handle(path: "tel://\(rawPhone)")
            }))
        }

        if !place.website.isEmpty {
            let website = place.website
            items.append(MapDetailViewModel(type: .website,
                                            content: place.website,
                                            action: { [weak self] in
                                                self?.handle(path: website)
            }))
        }

        if !place.facebook.isEmpty {
            let fb = place.facebook
            items.append(MapDetailViewModel(type: .facebook,
                                              content: place.facebook,
                                              action: { [weak self] in
                                                self?.handle(path: fb)
            }))
        }

        if !place.address.isEmpty {
            items.append(MapDetailViewModel(type: .address,
                                            content: place.address,
                                            action: nil))
        }
        if let workingHours = place.currentWorkingDay?.workingHours {
            items.append(MapDetailViewModel(type: .workingHours,
                                            content: workingHours,
                                            action: nil))
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
        if !place.address.isEmpty {
            return "\(place.type) · \(place.address)"
        }
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
