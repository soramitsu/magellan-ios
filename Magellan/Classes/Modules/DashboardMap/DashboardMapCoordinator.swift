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
    var modalDismissableTransition: ModalDismissableTransition?
    weak var mapView: MapViewProtocol?
    
    init(container: DashboardMapViewController, resolver: ResolverProtocol) {
        self.container = container
        self.resolver = resolver
    }
}

extension DashboardMapCoordinator: MapCoordinatorProtocol {
    
    func setMapList(state: DraggableState, animated: Bool) {
        dragableNavigation?.set(dragableState: state, animated: animated)
    }
    
    func hideDetailsIfPresented() {
        if let presentedVC = container?.presentedViewController as? LocationDetailsViewController {
            presentedVC.dismiss(animated: true)
        }
    }
    
    func showDetails(for placeInfo: PlaceInfo) {
        hideDetailsIfPresented()
        setMapList(state: .compact, animated: true)
        
        let detailsView = LocationDetailsAssembly.assemble(placeInfo: placeInfo, resolver: resolver, decorator: LocationDetailsReviewablePresenter.self)
        detailsView.presenter.delegate = self
        
        let controller = detailsView.controller
        modalTransition = ModalDraggableTransition()
        modalTransition?.underlyingView = mapView?.controller.view
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
        
        filterView.presenter.coordinator = self
        filterView.presenter.output = output
        let controller = filterView.controller
        modalDismissableTransition = ModalDismissableTransition()
        controller.transitioningDelegate = modalDismissableTransition
        controller.modalPresentationStyle = .custom
        container?.present(controller, animated: true, completion: nil)
    }

    func dismiss() {
        modalTransition = nil
        mapView?.presenter.removeSelection()
    }
}

extension DashboardMapCoordinator: LocationDetailsPresenterDelegate { }
extension DashboardMapCoordinator: CategoriesFilterCoordinatorProtocol { }

extension DashboardMapCoordinator: MapListPresenterDelegate {
    
    func collapseList() {
        dragableNavigation?.draggableDelegate?.wantsTransit(to: .compact, animating: true)
    }
    
    func expandList() {
        dragableNavigation?.draggableDelegate?.wantsTransit(to: .full, animating: true)
    }
    
}
