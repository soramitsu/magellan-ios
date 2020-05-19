//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class CategoriesFilterPresenter {
    
    let categories: [PlaceCategory]
    let defaultFilter: Set<PlaceCategory>
    var filter: Set<PlaceCategory>
    weak var view: CategoriesFilterViewProtocol?
    weak var coordinator: CategoriesFilterCoordinatorProtocol?
    weak var output: CategoriesFilterOutputProtocol?
    
    init(categories: [PlaceCategory], filter: Set<PlaceCategory>) {
        self.categories = categories
        self.filter = filter
        self.defaultFilter = filter
    }
    
}

extension CategoriesFilterPresenter: CategoriesFilterPresenterProtocol {
    
    var countOfCategories: Int {
        return categories.count
    }
    
    func dismiss() {
        output?.categoriesFilter(filter)
    }
    
    func viewModel(_ index: Int) -> CategoryFilterViewModel {
        let item = categories[index]
        return CategoryFilterViewModel(category: item,
                                       isSelected: filter.contains(item))
    }
    
    func select(with index: Int) {
        filter.insert(categories[index])
    }
    
    func deselect(with index: Int) {
        filter.remove(categories[index])
    }
    
    func resetFilter() {
        filter = defaultFilter
        view?.reload()
    }
    
}
