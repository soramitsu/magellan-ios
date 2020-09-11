//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import XCTest
@testable import Magellan

class ScheduleTest: XCTestCase {
    
    func workingDay(_ dayOfWeek: Day) -> WorkingDay {
        return WorkingDay(dayOfWeek: dayOfWeek,
                          from: .init(hour: 9, minute: 0), to: .init(hour: 18, minute: 0), lunchTimeFrom: .init(hour: 13, minute: 0), lunchTimeTo: .init(hour: 14, minute: 0))
    }
    
    func testDaily() {
        let schedule = Schedule(open24: false, workDays: [
            workingDay(.Monday),
            workingDay(.Tuesday),
            workingDay(.Wednesday),
            workingDay(.Thursday),
            workingDay(.Friday),
            workingDay(.Saturday),
            workingDay(.Sunday),
        ])
        let viewModel = ScheduleViewModel(schedule: schedule, weekDayNumber: 1)
        
        XCTAssertTrue(viewModel.isDaily)
        XCTAssertEqual(viewModel.description(with: DefaultLocalizedResorcesFactory()), "Daily 9:00 - 18:00\nLunch time 13:00 - 14:00")
    }
    
    func testTodayWithoutDay() {
        let schedule = Schedule(open24: false, workDays: [
            workingDay(.Monday),
            workingDay(.Tuesday),
            workingDay(.Wednesday),
            workingDay(.Thursday),
            workingDay(.Friday),
            workingDay(.Saturday),
        ])
        let viewModel = ScheduleViewModel(schedule: schedule, weekDayNumber: 1)
        
        XCTAssertFalse(viewModel.isDaily)
        XCTAssertEqual(viewModel.description(with: DefaultLocalizedResorcesFactory()), "Today 9:00 - 18:00\nLunch time 13:00 - 14:00")
    }
    
    func testToday() {
        let schedule = Schedule(open24: false, workDays: [
            workingDay(.Monday),
            workingDay(.Tuesday),
            workingDay(.Wednesday),
            workingDay(.Thursday),
            workingDay(.Friday),
            workingDay(.Saturday),
            WorkingDay(dayOfWeek: .Saturday,
            from: .init(hour: 9, minute: 0), to: .init(hour: 19, minute: 0), lunchTimeFrom: .init(hour: 13, minute: 0), lunchTimeTo: .init(hour: 14, minute: 0))
        ])
        let viewModel = ScheduleViewModel(schedule: schedule, weekDayNumber: 1)
        
        XCTAssertFalse(viewModel.isDaily)
        XCTAssertEqual(viewModel.description(with: DefaultLocalizedResorcesFactory()), "Today 9:00 - 18:00\nLunch time 13:00 - 14:00")
    }
    
}
