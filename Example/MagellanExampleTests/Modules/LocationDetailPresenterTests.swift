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
                        distance: "dist",
                        workSchedule: Schedule(open24: true, workDays: nil),
                        score: 3.9)
    }
    
    func testDismiss() {
        // arrange
        let presenter = LocationDetailsPresenter(placeInfo: self.placeInfo,
                                                 localizedResourcesFactory: DefaultLocalizedResorcesFactory())
        let coordinator = LocationDetailsPresenterDelegateMock()
        presenter.delegate = coordinator
        
        // act
        presenter.dismiss()
        
        // assert
        XCTAssertTrue(coordinator.dismissCalled)
    }
    
    func testProperties() {
        // arrange
        let presenter = LocationDetailsPresenter(placeInfo: self.placeInfo,
                                                 localizedResourcesFactory: DefaultLocalizedResorcesFactory())
        
        // act
        presenter.viewDidLoad()
        let viewModel = presenter.items.first?.items.first as? LocationHeaderViewModel
        
        // assert
        XCTAssertEqual(viewModel?.title, "name")
        XCTAssertEqual(viewModel?.comment, "type · addr")
        XCTAssertEqual(viewModel?.status, nil)
        XCTAssertEqual(viewModel?.subStatus, "Open 24 hours")
        XCTAssertEqual(presenter.items.count, 2)
    }
}
