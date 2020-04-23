//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import Nimble
import Quick
@testable import Magellan
@testable import MagellanExample

final class LocationDetailPresenterSpec: QuickSpec {
    
    var placeInfo: PlaceInfo {
        return PlaceInfo(id: 1,
                        name: "name",
                        type: "type",
                        coordinates: Coordinates(lat: 1, lon: 1),
                        address: "addr",
                        phoneNumber: "+855000000009",
                        openHours: "open",
                        website: "website",
                        facebook: "fb",
                        logoUuid: "logoUiid",
                        promoImageUuid: "promoUiid",
                        distance: "dist")
    }
    
    override func spec() {
        describe("LocationDetail logic tests") {
            
            it("dismiss logic") {
                let presenter = LocationDetailsPresenter(placeInfo: self.placeInfo)
                let coordinator = LocationDetailsPresenterDelegateMock()
                presenter.delegate = coordinator
                
                presenter.dismiss()
                
                expect(coordinator.dismissCalled).to(beTrue())
            }
            
            it("table helper") {
                let tableHelper = DefaultMapDetailTableHelper(place: self.placeInfo)
                let tableHelperDelegate = MapDetailTableHelperDelegateMock()
                tableHelper.delegate = tableHelperDelegate
                
                tableHelper.items.forEach {
                    $0.action?()
                }
                
                expect(tableHelperDelegate.hanldePathCallsCount).to(equal(3))
            }
            
            
        }
    }
}
