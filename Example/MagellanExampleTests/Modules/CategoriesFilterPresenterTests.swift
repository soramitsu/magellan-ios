//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import XCTest
@testable import Magellan

class CategoriesFilterPresenterTests: XCTestCase {
    
    var presenter: CategoriesFilterPresenter!
    var view: CategoriesFilterViewProtocolMock!
    var output: CategoriesFilterOutputProtocolMock!
    var coordinator: CategoriesFilterCoordinatorProtocolMock!
    
    var categories: [PlaceCategory] {
        
        return [
            PlaceCategory(id: 0, name: "zero"),
            PlaceCategory(id: 1, name: "first"),
            PlaceCategory(id: 2, name: "second"),
        ]
    }
    
    var defaultFilter: Set<PlaceCategory> {
        return Set(categories.suffix(from: 1))
    }

    override func setUp() {
        view = CategoriesFilterViewProtocolMock()
        output = CategoriesFilterOutputProtocolMock()
        coordinator = CategoriesFilterCoordinatorProtocolMock()
        presenter = CategoriesFilterPresenter(categories: categories, filter: defaultFilter,
                                              localizator: DefaultLocalizedResorcesFactory())
        presenter.view = view
        presenter.output = output
        presenter.coordinator = coordinator
        
        super.setUp()
    }
    
    func testDecelect() {
        
        // act
        presenter.deselect(with: 2)
        presenter.dismiss()
        
        // assert
        XCTAssertTrue(output.categoriesFilterReceivedFilter?.count == 1)
        XCTAssertEqual(output.categoriesFilterReceivedFilter, Set(arrayLiteral: categories[1]))
    }
    
    func testSelect() {
        
        // act
        presenter.select(with: 0)
        presenter.dismiss()
        
        // assert
        XCTAssertTrue(output.categoriesFilterReceivedFilter?.count == 3)
        XCTAssertEqual(output.categoriesFilterReceivedFilter, Set(categories))
    }
    
    func testReset() {
        
        // act
        presenter.deselect(with: 1)
        presenter.deselect(with: 2)
        XCTAssertEqual(presenter.filter.count, 0)
        presenter.resetFilter()
        presenter.dismiss()
        
        // assert
        XCTAssertTrue(output.categoriesFilterReceivedFilter?.count == 2)
        XCTAssertEqual(output.categoriesFilterReceivedFilter, defaultFilter)
    }
    
    func testCountOfCategories() {
        // assert
        XCTAssertEqual(presenter.countOfCategories, 3)
    }
    
    func testViewModel() {
        
        // act
        let zeroVM = presenter.viewModel(0)
        let firstVM = presenter.viewModel(1)
        let secondVM = presenter.viewModel(2)
        
        XCTAssertFalse(zeroVM.isSelected)
        XCTAssertTrue(firstVM.isSelected)
        XCTAssertTrue(secondVM.isSelected)
    }

}
