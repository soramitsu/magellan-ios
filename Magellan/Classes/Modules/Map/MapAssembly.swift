//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

final class MapAssembly {
    static func assembly(with resolver: ResolverProtocol) -> MapViewProtocol {
        let locationService = UserLocationService(distanceFilter: resolver.distanceFilter)
        
        let presenter = MapPresenter(service: resolver.networkService,
                                     locationService: locationService,
                                     defaultPosition: resolver.defaultCoordinate,
                                     localizator: resolver.localizationResourcesFactory)
        presenter.set(parameters: resolver.parameters)
        presenter.logger = resolver.logger
        presenter.alertHelper = resolver.alertHelper
        
        let decorator = MapReviewablePresenter(decorated: presenter,
                                               service: resolver.networkService,
                                               localizator: resolver.localizationResourcesFactory)
        
        let markerFactory = resolver.markerFactory ?? MapMarkerDefaultFactory()
        let mapView = MapViewController(presenter: decorator, markerFactory: markerFactory, style: resolver.style)
        decorator.view = mapView
        
        return mapView
    }
}
