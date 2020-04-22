/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol DashboardMapViewProtocol: class, ControllerBackedProtocol, Loadable, AutoMockable {
    var presenter: DashboardMapPresenterProtocol { get }
}

protocol DashboardMapPresenterProtocol: AnyObject {
    var view: DashboardMapViewProtocol? { get set }
}

protocol DashboardMapCoordinatorProtocol: AutoMockable {
    var presenter: DashboardMapPresenterProtocol? { get set }
    
    func showDetails(for placeInfo: PlaceInfo)
}

protocol DashboardMapAssemblyProtocol {
    static func assembly(with resolver: ResolverProtocol) -> UIViewController
}
