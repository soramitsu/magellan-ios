//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol CategoriesFilterCoordinatorProtocol: AnyObject, AutoMockable {
    func dismiss()
}

protocol CategoriesFilterPresenterProtocol: AnyObject {
    
    var countOfCategories: Int { get }
    var view: CategoriesFilterViewProtocol? { get set }
    var coordinator: CategoriesFilterCoordinatorProtocol? { get set }
    var output: CategoriesFilterOutputProtocol? { get set }
    
    func viewModel(_ index: Int) -> CategoryFilterViewModel
    func deselect(with index: Int)
    func select(with index: Int)
    func resetFilter()
    func dismiss()
}

protocol CategoriesFilterViewProtocol: ControllerBackedProtocol, AutoMockable {
    var presenter: CategoriesFilterPresenterProtocol { get }
    
    func reload()
}

protocol CategoriesFilterOutputProtocol: AnyObject, AutoMockable {
    func categoriesFilter(_ filter: Set<PlaceCategory>)
}
