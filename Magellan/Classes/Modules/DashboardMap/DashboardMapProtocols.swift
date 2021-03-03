/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol DashboardMapViewProtocol: class, ControllerBackedProtocol, AutoMockable {
    var presenter: DashboardMapPresenterProtocol { get }
    
    func set(title: String)
}

protocol DashboardMapPresenterProtocol: AnyObject {
    var view: DashboardMapViewProtocol? { get }
    var coordinator: DashboardMapCoordinatorProtocol? { get }
}

protocol DashboardMapCoordinatorProtocol: AutoMockable {
    var presenter: DashboardMapPresenterProtocol? { get }
}

protocol DashboardMapAssemblyProtocol {
    static func assembly(with resolver: ResolverProtocol) -> UIViewController
}
