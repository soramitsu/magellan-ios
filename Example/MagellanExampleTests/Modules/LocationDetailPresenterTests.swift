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
                        region: "KH",
                        website: "website",
                        facebook: "fb",
                        logoUuid: "logoUiid",
                        promoImageUuid: "promoUiid",
                        distance: "dist", workSchedule: Schedule(open24: true, workDays: nil))
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
    
    func testProperties() {
        // arrange
        
        // act
        let presenter = LocationDetailsPresenter(placeInfo: self.placeInfo)
        
        // assert
        XCTAssertEqual(presenter.title, "name")
        XCTAssertEqual(presenter.category, "type · addr")
        XCTAssertEqual(presenter.distance, "dist")
        XCTAssertEqual(presenter.workingStatus, "Open")
        XCTAssertEqual(presenter.items.count, 4)
    }
}
