//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan

struct TestWorkingHours: WorkingStatusProtocol {

    var day: String? {
        Calendar.current.shortStandaloneWeekdaySymbols[Calendar.current.component(.weekday, from: currentDate)]
    }

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

    var beforeLaunchDate: Date {
        return date(string: "2016-04-14T13:02:00")
    }

    var launchDate: Date {
        return date(string: "2016-04-14T13:44:00")
    }

    var afterLaunchDate: Date {
        return date(string: "2016-04-14T14:44:00")
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
    
    let resources = WorkingStatusResources(open: "open",
                                           closed: "closed",
                                           until: "until",
                                           opens: "opens",
                                           closes: "closes",
                                           reopens: "reopens")
    
    override func setUp() {
        testItem = TestWorkingHours(currentDate: befoOpensDate,
                                    opensTime: "9:00",
                                    closesTime: "18:00",
                                    workingHours: "9:00-18:00",
                                    opensTimeInterval: 9 * 60 * 60,
                                    closesTimeInterval: 18 * 60 * 60)
        testItem.startLaunchTime = "13:30"
        testItem.startLaunchTimeInterval = 13 * 60 * 60 + 30 * 60
        testItem.finishLaunchTime = "14:30"
        testItem.finishLaunchTimeInterval = 14 * 60 * 60 + 30 * 60
        super.setUp()
    }
    
    override func tearDown() {
        testItem = nil
        super.tearDown()
    }
    
    func testDayComponents() {
        // act
        let beforeComponents = Calendar.current.dateComponents([.hour, .minute], from: befoOpensDate)
        let beforeLaunchComponents = Calendar.current.dateComponents([.hour, .minute], from: beforeLaunchDate)
        let launchComponents = Calendar.current.dateComponents([.hour, .minute], from: launchDate)
        let afterLaunchComponents = Calendar.current.dateComponents([.hour, .minute], from: afterLaunchDate)
        let afterComponents = Calendar.current.dateComponents([.hour, .minute], from: afterCloseDate)
        
        // assert
        XCTAssertEqual(beforeComponents.hour, 2)
        XCTAssertEqual(beforeComponents.minute, 44)
        
        XCTAssertEqual(beforeLaunchComponents.hour, 13)
        XCTAssertEqual(beforeLaunchComponents.minute, 02)

        XCTAssertEqual(launchComponents.hour, 13)
        XCTAssertEqual(launchComponents.minute, 44)

        XCTAssertEqual(afterLaunchComponents.hour, 14)
        XCTAssertEqual(afterLaunchComponents.minute, 44)
        
        XCTAssertEqual(afterComponents.hour, 20)
        XCTAssertEqual(afterComponents.minute, 44)
    
    }
    
    func testBeforeOpen() {
        // arrange
        var item = testItem!
        item.currentDate = befoOpensDate
        
        // act
        let result = item.status(with: resources, nextWorkingDay: nil)
        
        // assert
        XCTAssertEqual(item.currentDate, befoOpensDate)
        XCTAssertEqual(result, "opens 9:00")
        XCTAssertFalse(item.isOpen)
    }

    func testBeforeLaunch() {
        // arrange
        var item = testItem!
        item.currentDate = beforeLaunchDate

        // act
        let result = item.status(with: resources, nextWorkingDay: nil)

        // assert
        XCTAssertEqual(item.currentDate, beforeLaunchDate)
        XCTAssertEqual(result, "closes 13:30, reopens 14:30")
        XCTAssertTrue(item.isOpen)
    }

    func testLaunch() {
        // arrange
        var item = testItem!
        item.currentDate = launchDate

        // act
        let result = item.status(with: resources, nextWorkingDay: nil)

        // assert
        XCTAssertEqual(item.currentDate, launchDate)
        XCTAssertEqual(result, "opens 14:30")
        XCTAssertFalse(item.isOpen)
    }

    func testAfterLaunch() {
        // arrange
        var item = testItem!
        item.currentDate = afterLaunchDate

        // act
        let result = item.status(with: resources, nextWorkingDay: nil)

        // assert
        XCTAssertEqual(item.currentDate, afterLaunchDate)
        XCTAssertEqual(result, "until 18:00")
        XCTAssertTrue(item.isOpen)
    }

    func testClosed() {
        // arrange
        var item = testItem!
        item.currentDate = afterCloseDate
        let nextWorkingDay = TestWorkingHours(currentDate: afterCloseDate.addingTimeInterval(24 * 3600),
                                              opensTime: "9:00",
                                              closesTime: "18:00",
                                              workingHours: "9:00-18:00",
                                              opensTimeInterval: 9 * 60 * 60,
                                              closesTimeInterval: 18 * 60 * 60)

        // act
        let result = item.status(with: resources, nextWorkingDay: nextWorkingDay)

        // assert
        XCTAssertEqual(item.currentDate, afterCloseDate)
        XCTAssertEqual(result, "opens 9:00 Sat")
        XCTAssertFalse(item.isOpen)
    }
    
}
