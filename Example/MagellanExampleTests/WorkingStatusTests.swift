//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan

class WorkingHoursTests: XCTestCase {
    
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
    
    var workingDay: WorkingDay {
        return WorkingDay(dayOfWeek: .Monday,
                          from: .init(hour: 9, minute: 00),
                          to: .init(hour: 19, minute: 00),
                          launchTimeFrom: .init(hour: 13, minute: 30),
                          launchTimeTo: .init(hour: 14, minute: 30))
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

    
    func viewModelWith(date: Date) -> WorkingDayViewModel {
        return WorkingDayViewModel(workingDay: workingDay, currentDate: date)
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
        let item = viewModelWith(date: befoOpensDate)
        
        // act
        let result = item.status(with: resources, nextWorkingDay: nil)
        
        // assert
        XCTAssertEqual(item.currentDate, befoOpensDate)
        XCTAssertEqual(result, "opens 9:00")
        XCTAssertFalse(item.isOpen)
    }

    func testBeforeLaunch() {
        // arrange
        let item = viewModelWith(date: beforeLaunchDate)

        // act
        let result = item.status(with: resources, nextWorkingDay: nil)

        // assert
        XCTAssertEqual(item.currentDate, beforeLaunchDate)
        XCTAssertEqual(result, "closes 13:30, reopens 14:30")
        XCTAssertTrue(item.isOpen)
    }

    func testLaunch() {
        // arrange
        let item = viewModelWith(date: launchDate)

        // act
        let result = item.status(with: resources, nextWorkingDay: nil)

        // assert
        XCTAssertEqual(item.currentDate, launchDate)
        XCTAssertEqual(result, "opens 14:30")
        XCTAssertFalse(item.isOpen)
    }

    func testAfterLaunch() {
        // arrange
        let item = viewModelWith(date: afterLaunchDate)

        // act
        let result = item.status(with: resources, nextWorkingDay: nil)

        // assert
        XCTAssertEqual(item.currentDate, afterLaunchDate)
        XCTAssertEqual(result, "until 19:00")
        XCTAssertTrue(item.isOpen)
    }

    func testClosed() {
        // arrange
        let item = viewModelWith(date: afterCloseDate)
        let nextWorkingDay = WorkingDayViewModel(workingDay: WorkingDay(dayOfWeek: .Saturday,
                                                                        from: .init(hour: 9, minute: 00),
                                                                        to: .init(hour: 19, minute: 00),
                                                                        launchTimeFrom: .init(hour: 13, minute: 30),
                                                                        launchTimeTo: .init(hour: 14, minute: 30)),
                                                 currentDate: afterCloseDate)

        // act
        let result = item.status(with: resources, nextWorkingDay: nextWorkingDay)

        // assert
        XCTAssertEqual(item.currentDate, afterCloseDate)
        XCTAssertEqual(result, "opens 9:00 Sat")
        XCTAssertFalse(item.isOpen)
    }
    
}
