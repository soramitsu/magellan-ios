/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

class DashboardMapAssembly: DashboardMapAssemblyProtocol {
    
    static func assembly(with resolver: ResolverProtocol) -> UIViewController {
        let presenter = DashboardMapPresenter()
        let dashboardMapController = DashboardMapViewController(presenter: presenter)
        presenter.view = dashboardMapController
        
        let mapView = MapAssembly.assembly(with: resolver)
        let dragableView = DraggableNavigationController()
        
        let mapListViewController = MapListAssembly.assembly(with: resolver)
        dragableView.setViewControllers([mapListViewController], animated: true)
        
        dashboardMapController.content = mapView
        dashboardMapController.draggable = dragableView
        
        let coordinator = DashboardMapCoordinator()
        coordinator.presenter = presenter
        
        presenter.coordinator = coordinator
        
        return dashboardMapController
    }
    
}

