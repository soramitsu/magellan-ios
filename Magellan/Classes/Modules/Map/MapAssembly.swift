//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

final class MapAssembly {
    static func assembly(with presenter: MapPresenterProtocol, resolver: ResolverProtocol) -> MapViewProtocol {
        let markerFactory = resolver.markerFactory ?? MapMarkerDefaultFactory()
        let mapView = MapViewController(presenter: presenter, markerFactory: markerFactory)
        presenter.mapView = mapView
        
        return mapView
    }
}
