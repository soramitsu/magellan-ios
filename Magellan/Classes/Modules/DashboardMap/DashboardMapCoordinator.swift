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
    
    var modalTransition: ModalDraggableTransition?
    weak var mapView: ControllerBackedProtocol?
    
    init(container: DashboardMapViewController, resolver: ResolverProtocol) {
        self.container = container
        self.resolver = resolver
    }
}

extension DashboardMapCoordinator: MapCoordinatorProtocol {
    func showDetails(for placeInfo: PlaceInfo) {
        dragableNavigation?.set(dragableState: .min, animated: true)
        
        let detailsView = LocationDetailsAssembly.assemble(placeInfo: placeInfo,
                                                           resolver: resolver,
                                                           overlayedView: mapView?.controller.view)
        detailsView.presenter.delegate = self
        
        let controller = detailsView.controller
        modalTransition = ModalDraggableTransition()
        controller.transitioningDelegate = modalTransition
        controller.modalPresentationStyle = .custom
        
        container?.present(controller, animated: true, completion: nil)
    }
    
    func showCategoriesFilter(categories: [PlaceCategory], filter: Set<PlaceCategory>, output: CategoriesFilterOutputProtocol?) {
        if let presentedVC = container?.presentedViewController as? LocationDetailsViewController {
            presentedVC.dismiss(animated: true) {
                presentedVC.presenter.dismiss()
            }
        }
        container?.presentedViewController?.dismiss(animated: true, completion: nil)
        let filterView = CategoriesFilterAssembly.assemble(with: resolver,
                                                           filter: filter,
                                                           categories: categories)
        filterView.presenter.output = output
        let controller = filterView.controller
        controller.modalPresentationStyle = .overCurrentContext
        container?.present(controller, animated: true, completion: nil)
    }
}

extension DashboardMapCoordinator: LocationDetailsPresenterDelegate {
    func dismiss() {
        dragableNavigation?.set(dragableState: .compact, animated: true)
        modalTransition = nil
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
