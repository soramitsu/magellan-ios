//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class DashboardMapCoordinator: DashboardMapCoordinatorProtocol {
    
    weak var container: DashboardMapViewController?
    let resolver: ResolverProtocol
    weak var presenter: DashboardMapPresenterProtocol?
    var dragableNavigation: DraggableNavigationController? {
        return container?.draggable as? DraggableNavigationController
    }
    
    init(container: DashboardMapViewController, resolver: ResolverProtocol) {
        self.container = container
        self.resolver = resolver
    }
}

extension DashboardMapCoordinator: MapCoordinatorProtocol {
    func showDetails(for placeInfo: PlaceInfo) {
        guard let navigation = dragableNavigation else {
            return
        }
        let detailsView = LocationDetailsAssembly.assemble(placeInfo: placeInfo, resolver: resolver)
        detailsView.presenter.delegate = self
        navigation.popToRootViewController(animated: false)
        navigation.pushViewController(detailsView.controller, animated: false)
    }
}

extension DashboardMapCoordinator: LocationDetailsPresenterDelegate {
    func dismiss() {
        dragableNavigation?.popViewController(animated: false)
    }
}

extension DashboardMapCoordinator: MapListPresenterDelegate {
    
    func collapseList() {
        dragableNavigation?.draggableDelegate?.wantsTransit(to: .compact, animating: true)
    }
    
    func expandList() {
        dragableNavigation?.draggableDelegate?.wantsTransit(to: .full, animating: true)
    }
    
}
