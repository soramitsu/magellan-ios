//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan
@testable import MagellanExample

final class MapListPresenterTests: XCTestCase {
    
    var presenter: MapListPresenter!
    var mapPresenter: MapPresenterProtocolMock!
    var view: MapListViewProtocolMock!
    
    var categoties: [Magellan.PlaceCategory] {
        return [
            Magellan.PlaceCategory(id: 1, name: "1", names: nil, khmerName: nil),
            Magellan.PlaceCategory(id: 2, name: "2", names: nil, khmerName: nil),
            Magellan.PlaceCategory(id: 3, name: "3", names: nil, khmerName: nil),
            Magellan.PlaceCategory(id: 4, name: "4", names: nil, khmerName: nil),
        ]
    }
    
    var places: [Place] {
        return [
            Place(id: "1", name: "first", type: "one", types: nil, khmerType: nil, coordinates: Coordinates(lat: 1, lon: 1)),
            Place(id: "2", name: "second", type: "one", types: nil, khmerType: nil, coordinates: Coordinates(lat: 2, lon: 2))
        ]
    }
    
    var placeInfo: PlaceInfo {
        return PlaceInfo(id: "1",
        name: "name",
        type: "type",
        types: nil,
        khmerType: nil,
        coordinates: Coordinates(lat: 1, lon: 1),
        address: "addr",
        phoneNumber: "+855000000009",
        region: "KH",
        website: "website",
        facebook: "fb",
        logoUuid: "logoUiid",
        promoImageUuid: "promoUiid",
        distance: "dist", workSchedule: Schedule(open24: true, workDays: nil))
    }
    
    var defaultPosition: Coordinates {
        return Coordinates(lat: 1, lon: 1)
    }
    
    override func setUp() {
        super.setUp()
        mapPresenter = MapPresenterProtocolMock()
        view = MapListViewProtocolMock()
        presenter = MapListPresenter(localizator: DefaultLocalizedResorcesFactory())
        presenter.view = view
        presenter.output = mapPresenter
    }
    
    override func tearDown() {
        super.tearDown()
        mapPresenter = nil
        view = nil
        presenter = nil
    }
    
    func testShowDetails() {
        // arrange
        let viewModel = PlaceViewModel(place: places.first!, locale: .en)
        
        // act
        presenter.showDetails(place: viewModel)
        
        // assert
        XCTAssertTrue(mapPresenter.selectPlaceCalled)
    }
    
    func testSearch() {
        // act
        presenter.search(with: "text")
        
        // assert
        XCTAssertTrue(mapPresenter.searchWithCalled)
    }
    
    func testSetCategoriesAndPlaces() {
        // arrange
        let items = places.compactMap { PlaceViewModel(place: $0, locale: .en) }
        
        // act
        presenter.didUpdate(places: items)
        
        // assert
        XCTAssertTrue(view.reloadPlacesCalled)
    }
    
}
