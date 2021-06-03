/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit


final class LocationDetailsAssembly {

    static func assemble(placeInfo: PlaceInfo, resolver: ResolverProtocol) -> LocationDetailsViewProtocol {
        
        let localizedResourcesFactory = resolver.localizationResourcesFactory
        let presenter = LocationDetailsPresenter(placeInfo: placeInfo,
                                                 localizedResourcesFactory: localizedResourcesFactory,
                                                 phoneFormatter: resolver.phoneFormatter)
        
        let dataSource = PlaceReviewDataSource(style: resolver.style,
                                               localizables: localizedResourcesFactory)
        let decorator = LocationDetailsReviewablePresenter(place: placeInfo,
                                                           decorated: presenter,
                                                           localizator: localizedResourcesFactory,
                                                           dataSource: dataSource)
        
        let view = LocationDetailsViewController(presenter: decorator,
                                                 style: resolver.style)
        decorator.view = view
        decorator.becomeObserver()
        return view
    }
}
