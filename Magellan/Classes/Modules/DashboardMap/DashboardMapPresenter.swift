/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import CoreLocation

final class DashboardMapPresenter: DashboardMapPresenterProtocol {
    
    let localizator: LocalizedResourcesFactoryProtocol
    weak var view: DashboardMapViewProtocol?
    var coordinator: DashboardMapCoordinatorProtocol?
    
    init(localizator: LocalizedResourcesFactoryProtocol) {
        self.localizator = localizator
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizationChanged),
                                               name: .init(rawValue: localizator.notificationName),
                                               object: nil)
    }
    
    @objc func localizationChanged() {
        view?.set(title: localizator.places)
    }
    
}
