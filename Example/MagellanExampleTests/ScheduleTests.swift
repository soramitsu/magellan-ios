//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan

class TestSchedule: Schedule {
    
    override var weekDayNumber: Int {
        return 1
    }
    
}
class ScheduleTest: XCTestCase {
    
    func workingDay(_ dayOfWeek: WorkingDay.Day) -> WorkingDay {
        return WorkingDay(dayOfWeek: dayOfWeek,
                          from: .init(hour: 9, minute: 0), to: .init(hour: 18, minute: 0), launchTimeFrom: .init(hour: 13, minute: 0), launchTimeTo: .init(hour: 14, minute: 0))
    }
    
    func testDaily() {
        let schedule = TestSchedule(open24: false, workDays: [
            workingDay(.Monday),
            workingDay(.Tuesday),
            workingDay(.Wednesday),
            workingDay(.Thursday),
            workingDay(.Friday),
            workingDay(.Saturday),
            workingDay(.Sunday),
        ])
        
        XCTAssertTrue(schedule.isDaily)
        XCTAssertEqual(schedule.description(with: DefaultLocalizedResorcesFactory()), "Daily 9:00 - 18:00\nLunch time 13:00 - 14:00")
    }
    
    func testTodayWithoutDay() {
        let schedule = TestSchedule(open24: false, workDays: [
            workingDay(.Monday),
            workingDay(.Tuesday),
            workingDay(.Wednesday),
            workingDay(.Thursday),
            workingDay(.Friday),
            workingDay(.Saturday),
        ])
        
        XCTAssertFalse(schedule.isDaily)
        XCTAssertEqual(schedule.description(with: DefaultLocalizedResorcesFactory()), "Today 9:00 - 18:00\nLunch time 13:00 - 14:00")
    }
    
    func testToday() {
        let schedule = TestSchedule(open24: false, workDays: [
            workingDay(.Monday),
            workingDay(.Tuesday),
            workingDay(.Wednesday),
            workingDay(.Thursday),
            workingDay(.Friday),
            workingDay(.Saturday),
            WorkingDay(dayOfWeek: .Saturday,
            from: .init(hour: 9, minute: 0), to: .init(hour: 19, minute: 0), launchTimeFrom: .init(hour: 13, minute: 0), launchTimeTo: .init(hour: 14, minute: 0))
        ])
        
        XCTAssertFalse(schedule.isDaily)
        XCTAssertEqual(schedule.description(with: DefaultLocalizedResorcesFactory()), "Today 9:00 - 18:00\nLunch time 13:00 - 14:00")
    }
    
}
