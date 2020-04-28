/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit


final class LocationDetailsAssembly {

    static func assemble(placeInfo: PlaceInfo, resolver: ResolverProtocol) -> LocationDetailsViewProtocol {
        let presenter = LocationDetailsPresenter(placeInfo: placeInfo)
        var tableHelper = resolver.locationDetailsTableHelperFactory?(placeInfo) ?? DefaultMapDetailTableHelper(place: placeInfo)
        tableHelper.delegate = presenter
        let view = LocationDetailsViewController(presenter: presenter,
                                                 style: resolver.locationDetailsViewStyle ?? DefaultLocationDetailsViewStyle(),
                                                 tableHelper: tableHelper)
        presenter.view = view
        return view
    }
}