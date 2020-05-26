/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol DashboardMapViewProtocol: class, ControllerBackedProtocol, AutoMockable {
    var presenter: DashboardMapPresenterProtocol { get }
}

protocol DashboardMapPresenterProtocol: AnyObject {
    var view: DashboardMapViewProtocol? { get set }
    var coordinator: DashboardMapCoordinatorProtocol? { get set }
}

protocol DashboardMapCoordinatorProtocol: AutoMockable {
    var presenter: DashboardMapPresenterProtocol? { get set }
}

protocol DashboardMapAssemblyProtocol {
    static func assembly(with resolver: ResolverProtocol) -> UIViewController
}
