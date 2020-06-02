//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan

struct TestWorkingHours: WorkingStatusProtocol {
    
    var startLaunchTime: String?
    
    var finishLaunchTime: String?
    
    var launchHours: String?
    
    var startLaunchTimeInterval: TimeInterval?
    
    var finishLaunchTimeInterval: TimeInterval?
    
    var currentDate: Date
    var opensTime: String
    var closesTime: String
    var workingHours: String
    var opensTimeInterval: TimeInterval
    var closesTimeInterval: TimeInterval
}

class WorkingHoursTests: XCTestCase {
    
    var testItem: TestWorkingHours!
    
    var befoOpensDate: Date {
        return date(string: "2016-04-14T02:44:00")
    }
    
    var workingDate: Date {
        return date(string: "2016-04-14T13:44:00")
    }
    
    var afterCloseDate: Date {
        return date(string: "2016-04-14T20:44:00")
    }
    
    func date(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from:string)!
    }
    
    override func setUp() {
        testItem = TestWorkingHours(currentDate: befoOpensDate,
                                    opensTime: "9:00",
                                    closesTime: "18:00",
                                    workingHours: "9:00-18:00",
                                    opensTimeInterval: 9 * 60 * 60,
                                    closesTimeInterval: 18 * 60 * 60)
        super.setUp()
    }
    
    override func tearDown() {
        testItem = nil
        super.tearDown()
    }
    
    func testDayComponents() {
        // act
        let beforeComponents = Calendar.current.dateComponents([.hour, .minute], from: befoOpensDate)
        let workingComponents = Calendar.current.dateComponents([.hour, .minute], from: workingDate)
        let afterComponents = Calendar.current.dateComponents([.hour, .minute], from: afterCloseDate)
        
        // assert
        XCTAssertEqual(beforeComponents.hour, 2)
        XCTAssertEqual(beforeComponents.minute, 44)
        
        XCTAssertEqual(workingComponents.hour, 13)
        XCTAssertEqual(workingComponents.minute, 44)
        
        XCTAssertEqual(afterComponents.hour, 20)
        XCTAssertEqual(afterComponents.minute, 44)
    
    }
    
    func testWillOpen() {
        // arrange
        var item = testItem!
        item.currentDate = befoOpensDate
        
        // act
        let result = item.status
        
        // assert
        XCTAssertEqual(item.currentDate, befoOpensDate)
        XCTAssertEqual(result, "Closed till 9:00")
        XCTAssertFalse(item.isOpen)
    }
    
    func testOpenTill() {
        // arrange
        var item = testItem!
        item.currentDate = workingDate
        
        // act
        let result = item.status
        
        // assert
        XCTAssertEqual(item.currentDate, workingDate)
        XCTAssertEqual(result, "Open till 18:00")
        XCTAssertTrue(item.isOpen)
    }
    
    func testClosedTill() {
        // arrange
        var item = testItem!
        item.currentDate = afterCloseDate
        
        // act
        let result = item.status
        
        // assert
        XCTAssertEqual(item.currentDate, afterCloseDate)
        XCTAssertEqual(result, "Closed")
        XCTAssertFalse(item.isOpen)
    }
    
}
