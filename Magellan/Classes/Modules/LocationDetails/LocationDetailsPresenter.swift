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
    private let localizator: LocalizedResorcesFactoryProtocol

    init(placeInfo: PlaceInfo, localizedResourcesFactory: LocalizedResorcesFactoryProtocol, phoneFormatter: PhoneFormatterProtocol? = nil) {
        place = placeInfo
        formatter = phoneFormatter
        self.localizator = localizedResourcesFactory
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizationChanged),
                                               name: .init(rawValue: localizator.notificationName),
                                               object: nil)
    }
    
    @objc func localizationChanged() {
        setupContent()
        view?.set(information: localizator.information)
    }
    
    func setupContent() {
        items.removeAll()
        if let phoneNumber = place.phoneNumber,
            !phoneNumber.isEmpty {
            let phone = formatter?.formattedPhoneNumber(with: phoneNumber, region: place.region) ?? phoneNumber
            items.append(MapDetailViewModel(type: .phone,
                                            title: MapDetailViewModelType.phone.title(with: localizator),
                                            content: phone,
                                            action: { [weak self] in
                                                self?.handle(path: "tel://\(phoneNumber)")
            }))
        }

        if let website = place.website,
            !website.isEmpty {
            items.append(MapDetailViewModel(type: .website,
                                            title: MapDetailViewModelType.website.title(with: localizator),
                                            content: website,
                                            action: { [weak self] in
                                                self?.handle(path: website)
            }))
        }

        if let facebook = place.facebook,
            !facebook.isEmpty {
            items.append(MapDetailViewModel(type: .facebook,
                                            title: MapDetailViewModelType.facebook.title(with: localizator),
                                            content: facebook,
                                            action: { [weak self] in
                                                self?.handle(path: facebook)
            }))
        }

        if !place.address.isEmpty {
            items.append(MapDetailViewModel(type: .address,
                                            title: MapDetailViewModelType.address.title(with: localizator),
                                            content: place.address,
                                            action: nil))
        }
        if let workingHours = place.currentWorkingDay?.workingHours {
            items.append(MapDetailViewModel(type: .workingHours,
                                            title: MapDetailViewModelType.address.title(with: localizator),
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
    
    func viewDidLoad() {
        setupContent()
        view?.set(information: localizator.information)
    }
    
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
        return place.distance ?? ""
    }
    
    var workingStatus: String {
        let resources = WorkingStatusResources(opened: localizator.open,
                                               closed: localizator.closed,
                                               openedTill: localizator.openTill,
                                               closedTill: localizator.closedTill)
        return place.workingStatus(with: resources)
        
    }
    
    var isOpen: Bool {
        place.isOpen
    }
    
    func dismiss() {
        delegate?.dismiss()
    }
    
}

extension LocationDetailsPresenter: UrlHandlerProtocol { }
