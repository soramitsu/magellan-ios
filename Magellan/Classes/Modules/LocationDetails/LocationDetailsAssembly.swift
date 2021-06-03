/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit


final class LocationDetailsAssembly {

    static func assemble(placeInfo: PlaceInfo, resolver: ResolverProtocol) -> LocationDetailsViewProtocol {
        
        let localizator = resolver.localizationResourcesFactory
        let presenter = LocationDetailsPresenter(placeInfo: placeInfo,
                                                 localizedResourcesFactory: localizator,
                                                 phoneFormatter: resolver.phoneFormatter)
        
        let dataSource = PlaceReviewDataSource(style: resolver.style)
        let decorator = LocationDetailsReviewablePresenter(place: placeInfo,
                                                           decorated: presenter,
                                                           localizator: localizator,
                                                           dataSource: dataSource)
        
        let view = LocationDetailsViewController(presenter: decorator,
                                                 style: resolver.style)
        decorator.view = view
        return view
    }
}
