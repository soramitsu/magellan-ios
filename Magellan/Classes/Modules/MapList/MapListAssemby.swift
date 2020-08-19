//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListAssembly {
    
    static func assembly(with resolver: ResolverProtocol) -> MapListViewProtocol {
        let presenter = MapListPresenter(localizator: resolver.localizationResourcesFactory)
        let view = MapListViewController(presenter: presenter, style: resolver.style)
        presenter.view = view
        
        return view
    }
    
}
