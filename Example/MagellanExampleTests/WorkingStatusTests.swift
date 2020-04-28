//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan

struct TestWorkingHours: WorkingStatusProtocol {
    var currentDate: Date
    var opensTime: String
    var closesTime: String
    var workingHours: String
    var opensTimeInterval: TimeInterval
    var closesTimeInterval: TimeInterval
}

class WorkingHoursTests: XCTestCase {
    
    var testItem: TestWorkingHours {
        return TestWorkingHours(currentDate: Date(),
                                opensTime: "9:00",
                                closesTime: "18:00",
                                workingHours: "9:00-18:00",
                                opensTimeInterval: 9 * 60 * 60,
                                closesTimeInterval: 18 * 60 * 60)
    }
    
    var befoOpensDate: Date {
        return date(string: "2016-04-14T02:44:00+0000")
    }
    
    var workingDate: Date {
        return date(string: "2016-04-14T13:44:00+0000")
    }
    
    var afterCloseDate: Date {
        return date(string: "2016-04-14T20:44:00+0000")
    }
    
    func date(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from:string)!
    }
    
    func testWillOpen() {
        // arrange
        var item = testItem
        item.currentDate = befoOpensDate
        
        // act
        let result = item.status
        
        // assert
        XCTAssertEqual(result, "Closed till 9:00")
        XCTAssertFalse(item.isOpen)
    }
    
    func testOpenTill() {
        // arrange
        var item = testItem
        item.currentDate = workingDate
        
        // act
        let result = item.status
        
        // assert
        XCTAssertEqual(result, "Open till 18:00")
        XCTAssertTrue(item.isOpen)
    }
    
    func testClosedTill() {
        // arrange
        var item = testItem
        item.currentDate = afterCloseDate
        
        // act
        let result = item.status
        
        // assert
        XCTAssertEqual(result, "Closed")
        XCTAssertFalse(item.isOpen)
    }
    
}
