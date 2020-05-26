/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit


final class LocationDetailsAssembly {

    static func assemble(placeInfo: PlaceInfo, resolver: ResolverProtocol, overlayedView: UIView?) -> LocationDetailsViewProtocol {
        let presenter = LocationDetailsPresenter(placeInfo: placeInfo, phoneFormatter: resolver.phoneFormatter)
        let view = LocationDetailsViewController(presenter: presenter,
                                                 style: resolver.style)
        view.overlayedView = overlayedView
        presenter.view = view
        return view
    }
}
