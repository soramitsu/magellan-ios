//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

class CategoriesFilterAssembly {
    
    static func assemble(with resolver: ResolverProtocol, filter: Set<PlaceCategory>,  categories: [PlaceCategory]) -> CategoriesFilterViewProtocol {
        var presenter = CategoriesFilterPresenter(categories: categories, filter: filter)
        let view = CategoriesFilterViewController(presenter: presenter, style: resolver.style)
        
        presenter.view = view
        
        return view
    }
}
