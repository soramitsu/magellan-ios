/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import MessageUI
import SafariServices

final class LocationDetailsReviewablePresenter {

    weak var view: LocationDetailsViewProtocol?
    let decorated: LocationDetailsDecorable
    let localizator: LocalizedResourcesFactoryProtocol
    let place: PlaceInfo
    let dataSource: PlaceReviewDataSource

    internal init(place: PlaceInfo,
                  decorated: LocationDetailsDecorable,
                  localizator: LocalizedResourcesFactoryProtocol,
                  dataSource: PlaceReviewDataSource) {
        self.place = place
        self.decorated = decorated
        self.localizator = localizator
        self.dataSource = dataSource
    }
    
    func setupContent() {
        decorated.setupContent()
        
        dataSource.provideModel(.init(place: place))
        
        
        view?.reload()
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

protocol LocationDetailsDecorable: LocationDetailsPresenterProtocol {
            
    func setItems(_ items: [LocationSectionViewModel])
    
    func setupContent()
}

extension LocationDetailsPresenter: LocationDetailsDecorable {
    
    func setItems(_ items: [LocationSectionViewModel]) {
        self.items = items
    }

}

final class LocationDetailsPresenter {
    
    weak var view: LocationDetailsViewProtocol?
    weak var delegate: LocationDetailsPresenterDelegate?
    let place: PlaceInfoViewModel
    let formatter: PhoneFormatterProtocol?
    private(set) var items: [LocationSectionViewModel] = []
    private let localizator: LocalizedResourcesFactoryProtocol

    init(placeInfo: PlaceInfo, localizedResourcesFactory: LocalizedResourcesFactoryProtocol, phoneFormatter: PhoneFormatterProtocol? = nil) {
        place = PlaceInfoViewModel(place: placeInfo)
        formatter = phoneFormatter
        self.localizator = localizedResourcesFactory
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizationChanged),
                                               name: .init(rawValue: localizator.notificationName),
                                               object: nil)
    }
    
    @objc func localizationChanged() {
        setupContent()
    }
    
    func setupContent() {
        items.removeAll()

        items.append(LocationSectionViewModel(title: nil,
                                              items: [
                                                LocationHeaderViewModel(place: place,
                                                                              localizator: localizator)
        ]))

        var infoItems: [CellViewModelProtocol] = []
        if let phoneNumber = place.phoneNumber,
            !phoneNumber.isEmpty {
            let phone = formatter?.formattedPhoneNumber(with: phoneNumber, region: place.region) ?? phoneNumber
            infoItems.append(MapDetailViewModel(type: .phone,
                                                content: phone,
                                                action: { [weak self] in
                                                    self?.handle(path: "tel://\(phoneNumber)")
            }))
        }

        if let website = place.website,
            !website.isEmpty {
            infoItems.append(MapDetailViewModel(type: .website,
                                                content: website,
                                                action: { [weak self] in
                                                    self?.handle(path: website)
            }))
        }

        if let facebook = place.facebook,
            !facebook.isEmpty {
            infoItems.append(MapDetailViewModel(type: .facebook,
                                                content: facebook,
                                                action: { [weak self] in
                                                    self?.handle(path: facebook)
            }))
        }

        if !place.address.isEmpty {
            infoItems.append(MapDetailViewModel(type: .address,
                                                content: place.address,
                                                action: nil))
        }
        
        
        if let scheduleDescription = place.workSchedule?.description(with: localizator) {
            infoItems.append(MapDetailViewModel(type: .workingHours,
                                                content: scheduleDescription,
                                                action: nil))
        }
        
        if !infoItems.isEmpty {
            items.append(LocationSectionViewModel(title: localizator.information, items: infoItems))
        }

        view?.reload()
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
    }
    
    func dismiss() {
        delegate?.dismiss()
    }
    
}

extension LocationDetailsPresenter: UrlHandlerProtocol { }
