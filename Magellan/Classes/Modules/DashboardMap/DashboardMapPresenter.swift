/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import CoreLocation

final class DashboardMapPresenter: DashboardMapPresenterProtocol {
    
    weak var view: DashboardMapViewProtocol?
    var coordinator: DashboardMapCoordinatorProtocol?
    
}
