//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan
@testable import MagellanExample

typealias MCategory = Magellan.Category

class MagellanServiceTest: XCTestCase {
    
    lazy var magellanService: MagellanServicePrototcol = {
        let baseUrl = URL(string: "https://pgateway1.s1.dev.bakong.soramitsu.co.jp")!
        let networkResolver = NetworkResolver(baseUrl: baseUrl)
        let middleware = MiddlewareOperationFactory(networkResolver: networkResolver)
        return MagellanService(operationFactory: middleware)
    }()
    
    
    
    //        mock(path: "/paymentservice/api/v1/merchants/{placeId}", filename: "placeInfo.json")
    //        mock(path: "/paymentservice/api/v1/merchants", filename: "placesList.json")
    
    func testCategoriesSuccess() {
        Mocks.mock(path: "/paymentservice/api/v1/merchants/types", filename: "types.json")
        let expectation = XCTestExpectation()
        var value: [MCategory] = []
        
        magellanService.getCategories(runCompletionIn: DispatchQueue.main) { result in
            switch result {
            case .failure:
                XCTFail("expected array of categories")
            case .success(let items):
                value = items
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertFalse(value.isEmpty)
    }
    
    func testCategoriesFail() {
        Mocks.mock(path: "/paymentservice/api/v1/merchants/types", filename: "fail.json")
        let expectation = XCTestExpectation()
        var expError: Error? = nil

        magellanService.getCategories(runCompletionIn: DispatchQueue.main) { result in
            switch result {
            case .failure(let error):
                expError = error
            case .success:
                XCTFail("expected error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(expError)
    }
    
    func testPlacesSuccess() {
        Mocks.mock(path: "/paymentservice/api/v1/merchants", filename: "placesList.json")
        let expectation = XCTestExpectation()
        var value: PlacesResponse? = nil
        let request = PlacesRequest(location: "geoHash", zoom: 10, search: nil, category: nil)
        
        magellanService.getPlaces(with: request, runCompletionIn: DispatchQueue.main) { result in
            switch result {
            case .failure:
                XCTFail("expected array of categories")
            case .success(let items):
                value = items
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(value)
        XCTAssertFalse(value?.locations.isEmpty == true)
    }
    
    func testPlacesFail() {
        Mocks.mock(path: "/paymentservice/api/v1/merchants", filename: "fail.json")
        let expectation = XCTestExpectation()
        var expError: Error? = nil
        let request = PlacesRequest(location: "geoHash", zoom: 10, search: nil, category: nil)
        
        magellanService.getPlaces(with: request, runCompletionIn: DispatchQueue.main) { result in
            switch result {
            case .failure(let error):
                expError = error
            case .success:
                XCTFail("expected error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(expError)
    }
    
    func testPlaceInfoSuccess() {
        Mocks.mock(path: "/paymentservice/api/v1/merchants/{placeId}", filename: "placeInfo.json")
        let expectation = XCTestExpectation()
        var value: PlaceInfo? = nil
        
        magellanService.getPlace(with: 1, runCompletionIn: DispatchQueue.main) { result in
            switch result {
            case .failure:
                XCTFail("expected array of categories")
            case .success(let item):
                value = item
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(value)
    }
    
    func testPlaceInfoFail() {
        Mocks.mock(path: "/paymentservice/api/v1/merchants/{placeId}", filename: "fail.json")
        let expectation = XCTestExpectation()
        var expError: Error? = nil

        magellanService.getPlace(with: 1, runCompletionIn: DispatchQueue.main) { result in
            switch result {
            case .failure(let error):
                expError = error
            case .success:
                XCTFail("expected error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(expError)
    }
    
}
