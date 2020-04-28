//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood
import XCTest
@testable import Magellan
@testable import MagellanExample

final class MapPresenterTests: XCTestCase {
    
    var presenter: MapPresenter!
    var listPresenter: MapListPresenterProtocolMock!
    var coordinator: MapCoordinatorProtocolMock!
    var mapView: MapViewProtocolMock!
    var service: MagellanServicePrototcolMock!
    var locationService: UserLocationServiceProtocolMock!
    
    var categoties: [Magellan.PlaceCategory] {
        return [
            Magellan.PlaceCategory(id: 1, name: "1"),
            Magellan.PlaceCategory(id: 2, name: "2"),
            Magellan.PlaceCategory(id: 3, name: "3"),
            Magellan.PlaceCategory(id: 4, name: "4"),
        ]
    }
    
    var places: [Place] {
        return [
            Place(id: 1, name: "first", type: "one", lat: 1, lon: 1),
            Place(id: 2, name: "second", type: "one", lat: 2, lon: 2)
        ]
    }
    
    var placeInfo: PlaceInfo {
        return PlaceInfo(id: 1,
                name: "name",
                type: "type",
                coordinates: Coordinates(lat: 1, lon: 1),
                address: "addr",
                phoneNumber: "+855000000009",
                region: "KH",
                website: "website",
                facebook: "fb",
                logoUuid: "logoUiid",
                promoImageUuid: "promoUiid",
                distance: "dist", workingSchedule: Schedule(opens24: true, workingDays: nil))
    }
    
    var defaultPosition: Coordinates {
        return Coordinates(lat: 1, lon: 1)
    }
    
    override func setUp() {
        super.setUp()
        service = MagellanServicePrototcolMock()
        coordinator = MapCoordinatorProtocolMock()
        mapView = MapViewProtocolMock()
        locationService = UserLocationServiceProtocolMock()
        listPresenter = MapListPresenterProtocolMock()
        
        presenter = MapPresenter(service: service,
                                 locationService: locationService,
                                 defaultPosition: self.defaultPosition)
        
        presenter.view = mapView
        presenter.coordinator = coordinator
        presenter.output = listPresenter
        
        mapView.presenter = presenter
    }
    
    override func tearDown() {
        super.tearDown()
        presenter = nil
        coordinator = nil
        mapView = nil
        service = nil
        locationService = nil
        listPresenter = nil
    }
    
    func testLocationUpdate() {
        // arrange
        locationService.currentLocation = Coordinates(lat: 1, lon: 1)
        service.getPlacesWithRunCompletionInCompletionClosure = { _, _, completion in
            completion(.success(PlacesResponse(locations: self.places, clusters: [])))
            return BaseOperation<Void>()
        }
        
        // act
        presenter.userLocationDidUpdate()
        
        // assert
        XCTAssertTrue(mapView.reloadDataCalled)
        XCTAssertTrue(listPresenter.didUpdatePlacesCalled)
    }
    
    func testLoadCategories() {
        // arrange
        service.getPlacesWithRunCompletionInCompletionClosure = { _, _, completion in
            completion(.success(PlacesResponse(locations: self.places, clusters: [])))
            return BaseOperation<Void>()
        }
        service.getCategoriesRunCompletionInCompletionClosure = { _, completion in
            completion(.success(self.categoties))
            return BaseOperation<Void>()
        }
        
        // act
        presenter.loadCategories()
        
        // assert
        XCTAssertTrue(mapView.reloadDataCalled)
        XCTAssertTrue(listPresenter.didUpdatePlacesCalled)
    }
    
    func testReset() {
        // arrange
        service.getPlacesWithRunCompletionInCompletionClosure = { _, _, completion in
            completion(.success(PlacesResponse(locations: self.places, clusters: [])))
            return BaseOperation<Void>()
        }
        
        // act
        presenter.reset()
        
        // assert
        XCTAssertTrue(mapView.reloadDataCalled)
        XCTAssertTrue(listPresenter.didUpdatePlacesCalled)
    }
    
    func testSelectCategory() {
        // arrange
        service.getPlacesWithRunCompletionInCompletionClosure = { _, _, completion in
            completion(.success(PlacesResponse(locations: self.places, clusters: [])))
            return BaseOperation<Void>()
        }
        
        // act
        presenter.select(category: "category")
        
        // assert
        XCTAssertTrue(mapView.reloadDataCalled)
        XCTAssertTrue(listPresenter.didUpdatePlacesCalled)
    }
    
    func testSearch() {
        // arrange
        service.getPlacesWithRunCompletionInCompletionClosure = { _, _, completion in
            completion(.success(PlacesResponse(locations: self.places, clusters: [])))
            return BaseOperation<Void>()
        }
        
        // act
        presenter.search(with: "text")
        
        // assert
        XCTAssertTrue(mapView.reloadDataCalled)
        XCTAssertTrue(listPresenter.didUpdatePlacesCalled)
    }
    
    func testShowDetails() {
        // arrange
        let viewModel = PlaceViewModel(place: self.places.first!)
        
        service.getPlaceWithRunCompletionInCompletionClosure = { _, _, completion in
            completion(.success(self.placeInfo))
            return BaseOperation<Void>()
        }
        
        // act
        presenter.showDetails(place: viewModel)
        
        // assert
        XCTAssertTrue(mapView.showLoadingCalled)
        XCTAssertTrue(mapView.hideLoadingCalled)
        XCTAssertTrue(coordinator.showDetailsForCalled)
        XCTAssertTrue(mapView.showPlaceCalled)
    }
    
    func testSelectPlace() {
        // arrange
        let viewModel = PlaceViewModel(place: self.places.first!)
        
        service.getPlaceWithRunCompletionInCompletionClosure = { _, _, completion in
            completion(.success(self.placeInfo))
            return BaseOperation<Void>()
        }
        
        // act
        presenter.select(place: viewModel)
        
        // assert
        XCTAssertTrue(mapView.showLoadingCalled)
        XCTAssertTrue(mapView.hideLoadingCalled)
        XCTAssertTrue(coordinator.showDetailsForCalled)
        XCTAssertTrue(mapView.showPlaceCalled)
    }
}