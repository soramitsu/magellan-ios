/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

class DashboardMapAssembly: DashboardMapAssemblyProtocol {
    
    static func assembly(with resolver: ResolverProtocol) -> UIViewController {
        let presenter = DashboardMapPresenter(localizator: resolver.localizationResourcesFactory)
        let dashboardMapController = DashboardMapViewController(presenter: presenter)
        presenter.view = dashboardMapController
        dashboardMapController.appearsClosure = resolver.moduleAppersClosure
        dashboardMapController.disappearsClosure = resolver.moduleDisappersClosure

        let mapView = MapAssembly.assembly(with: resolver)
        let dragableView = DraggableNavigationController()

        let mapListView = MapListAssembly.assembly(with: resolver)
        dragableView.setViewControllers([mapListView.controller], animated: true)

        dashboardMapController.content = mapView
        dashboardMapController.draggable = dragableView

        let coordinator = DashboardMapCoordinator(container: dashboardMapController, resolver: resolver)
        coordinator.mapView = mapView
        coordinator.presenter = presenter

        mapView.presenter.coordinator = coordinator
        
        mapView.presenter.output = mapListView.presenter
        mapListView.presenter.output = mapView.presenter
        mapListView.presenter.delegate = coordinator
        
        
        return dashboardMapController
    }
    
}

