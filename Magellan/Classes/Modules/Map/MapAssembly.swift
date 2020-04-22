//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

final class MapAssembly {
    static func assembly(with resolver: ResolverProtocol) -> MapViewProtocol {
        let presenter = MapPresenter()
        let mapView = MapViewController(presenter: presenter)
        presenter.view = mapView
        
        return mapView
    }
}
