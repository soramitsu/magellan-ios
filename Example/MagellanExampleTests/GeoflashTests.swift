//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import XCTest
@testable import Magellan

class GeoflashTests: XCTestCase {

    func testGeoHash() {
        
        XCTAssertEqual(Geoflash.hash(latitude: 48.668983, longitude: -4.329021, precision: 9), "gbsuv7ztq")
        XCTAssertEqual(Geoflash.hash(latitude: 50, longitude: 50, precision: 9), "v0gs3y0zh")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 9), "v1xzec3k0")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 8), "v1xzec3k")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 7), "v1xzec3")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 6), "v1xzec")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 5), "v1xze")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 4), "v1xz")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 3), "v1x")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 2), "v1")
        XCTAssertEqual(Geoflash.hash(latitude: 54.763425, longitude: 56.06499, precision: 1), "v")
        
        
    }

}
