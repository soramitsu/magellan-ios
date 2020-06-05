/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import CoreLocation

final class DashboardMapPresenter: DashboardMapPresenterProtocol {
    
    let localizator: LocalizedResorcesFactoryProtocol
    weak var view: DashboardMapViewProtocol?
    var coordinator: DashboardMapCoordinatorProtocol?
    
    init(localizator: LocalizedResorcesFactoryProtocol) {
        self.localizator = localizator
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizationChanged),
                                               name: .init(rawValue: localizator.notificationName),
                                               object: nil)
    }
    
    @objc func localizationChanged() {
        
    }
    
}
