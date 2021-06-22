/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */

import UIKit


final class LocationDetailsAssembly {
    static func assemble(placeInfo: PlaceInfo,
                         resolver: ResolverProtocol) -> LocationDetailsViewProtocol {
        let presenter = LocationDetailsPresenter(placeInfo: placeInfo,
                                                 localizedResourcesFactory: resolver.localizationResourcesFactory,
                                                 phoneFormatter: resolver.phoneFormatter)
        let view = LocationDetailsViewController(presenter: presenter,
                                                 style: resolver.style)
        presenter.view = view
        return view
    }
    
    static func assemble<Decorator>(placeInfo: PlaceInfo,
                                    resolver: ResolverProtocol,
                                    decorator: Decorator.Type) -> LocationDetailsViewProtocol where Decorator: LocationDetailsReviewablePresenter {
        
        let localizedResourcesFactory = resolver.localizationResourcesFactory
        let presenter = LocationDetailsPresenter(placeInfo: placeInfo,
                                                 localizedResourcesFactory: localizedResourcesFactory,
                                                 phoneFormatter: resolver.phoneFormatter)
        
        let dataSource = PlaceReviewDataSource(style: resolver.style,
                                               localizables: localizedResourcesFactory)
        let decorator = Decorator(place: placeInfo,
                                  decorated: presenter,
                                  service: resolver.networkService,
                                  localizator: localizedResourcesFactory,
                                  dataSource: dataSource)
        
        let view = LocationDetailsViewController(presenter: decorator,
                                                 style: resolver.style)
        decorator.view = view
        decorator.becomeObserver()
        dataSource.presenter = decorator
        
        return view
    }
    
}
