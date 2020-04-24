//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListAssembly {
    
    static func assembly(with resolver: ResolverProtocol) -> MapListViewProtocol {
        let presenter = MapListPresenter()
        let view = MapListViewController(presenter: presenter, style: resolver.mapListStyle ?? DefaultMapListViewStyle())
        
        presenter.view = view
        
        return view
    }
    
}
