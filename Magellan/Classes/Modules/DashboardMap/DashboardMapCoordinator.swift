//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class DashboardMapCoordinator: DashboardMapCoordinatorProtocol {
    
    var presenter: DashboardMapPresenterProtocol?
    
    var mapPresenter: MapPresenterProtocol? {
        didSet {
            mapPresenter?.delegate = self as MapCoordinatorProtocol
        }
    }
    
    var mapListPresenter: MapListPresenterProtocol? {
        didSet {
            mapListPresenter?.delegate = self as MapListCoordinatorProtocol
        }
    }
    
    
}

extension DashboardMapCoordinator: MapCoordinatorProtocol { }
extension DashboardMapCoordinator: MapListCoordinatorProtocol {
    func showPlace(_ place: PlaceInfo) {
        //todo: show place controller
    }
}
