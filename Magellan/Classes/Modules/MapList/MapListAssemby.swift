//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListAssembly {
    
    static func assembly(with presenter: MapListPresenterProtocol, resolver: ResolverProtocol) -> MapListViewProtocol {
        let view = MapListViewController(presenter: presenter, style: resolver.mapListStyle ?? DefaultMapListViewStyle())
        
        presenter.listView = view
        
        return view
    }
    
}
