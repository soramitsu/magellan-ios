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
                                     defaultPosition: resolver.defaultCoordinate)
        
        let markerFactory = resolver.markerFactory ?? MapMarkerDefaultFactory()
        let mapView = MapViewController(presenter: presenter, markerFactory: markerFactory)
        presenter.view = mapView
        
        return mapView
    }
}
