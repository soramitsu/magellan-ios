//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan
@testable import MagellanExample

final class LocationDetailPresenterTests: XCTestCase {
    
    var placeInfo: PlaceInfo {
        return PlaceInfo(id: 1,
                        name: "name",
                        type: "type",
                        coordinates: Coordinates(lat: 1, lon: 1),
                        address: "addr",
                        phoneNumber: "+855000000009",
                        website: "website",
                        facebook: "fb",
                        logoUuid: "logoUiid",
                        promoImageUuid: "promoUiid",
                        distance: "dist", workingSchdule: Schedule(opens24: true, workingDays: nil))
    }
    
    func testDismiss() {
        // arrange
        let presenter = LocationDetailsPresenter(placeInfo: self.placeInfo)
        let coordinator = LocationDetailsPresenterDelegateMock()
        presenter.delegate = coordinator
        
        // act
        presenter.dismiss()
        
        // assert
        XCTAssertTrue(coordinator.dismissCalled)
    }
    
    func testTableHelper() {
        // arrange
        let tableHelper = DefaultMapDetailTableHelper(place: self.placeInfo)
        let tableHelperDelegate = MapDetailTableHelperDelegateMock()
        tableHelper.delegate = tableHelperDelegate
        
        // act
        tableHelper.items.forEach {
            $0.action?()
        }
        
        // assert
        XCTAssertEqual(tableHelperDelegate.hanldePathCallsCount, 3)
    }
}
