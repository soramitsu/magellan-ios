/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol DashboardMapViewProtocol: class, ControllerBackedProtocol {
    var presenter: DashboardMapPresenterProtocol { get }
}

protocol DashboardMapPresenterProtocol {
    var view: DashboardMapViewProtocol? { get set }
}

protocol DashboardMapCoordinatorProtocol {
    var presenter: DashboardMapPresenterProtocol? { get set }
    var mapPresenter: MapPresenterProtocol? { get set }
    var mapListPresenter: MapListPresenterProtocol? { get set }
}

protocol DashboardMapAssemblyProtocol {
    static func assembly(with resolver: ResolverProtocol) -> UIViewController
}
