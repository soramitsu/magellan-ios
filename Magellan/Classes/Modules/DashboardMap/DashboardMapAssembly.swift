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

        let mapListView = MapListAssembly.assembly(with: resolver)
        dragableView.setViewControllers([mapListView.controller], animated: true)

        dashboardMapController.content = mapView
        dashboardMapController.draggable = dragableView

        let coordinator = DashboardMapCoordinator(container: dashboardMapController, resolver: resolver)
        coordinator.presenter = presenter
        presenter.coordinator = coordinator

        mapView.presenter.coordinator = coordinator
        
        mapView.presenter.output = mapListView.presenter
        mapListView.presenter.output = mapView.presenter
        mapListView.presenter.delegate = coordinator
        
        
        return dashboardMapController
    }
    
}

