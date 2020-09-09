//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct WorkingDayViewModel {
    
    let workingDay: WorkingDay
    let currentDate: Date
    
    init(workingDay: WorkingDay, currentDate: Date = Date()) {
        self.workingDay = workingDay
        self.currentDate = currentDate
    }
    
    var day: String? {
        return Calendar.current.shortStandaloneWeekdaySymbols[dayOfWeek.numberOfWeek]
    }
    
    var dayOfWeek: Day {
        return workingDay.dayOfWeek
    }
    
    var from: Time {
        return workingDay.from
    }
    
    var to: Time {
        return workingDay.to
    }
    
    var lunchTimeFrom: Time? {
        return workingDay.launchTimeFrom
    }
    
    var lunchTimeTo: Time? {
        return workingDay.launchTimeTo
    }
    
}

extension WorkingDayViewModel: WorkingStatusProtocol {

    var opensTime: String {
        return from.description
    }
    
    var closesTime: String {
        return to.description
    }
    
    var workingHours: String {
        return "\(from.description) - \(to.description)"
    }
    
    var startLaunchTime: String? {
        return lunchTimeFrom?.description
    }
    var finishLaunchTime: String? {
        return lunchTimeTo?.description
    }
    
    var launchHours: String? {
        guard let launchTimeFrom = lunchTimeFrom,
            let launchTimeTo = lunchTimeTo else {
                return nil
        }
        return "\(launchTimeFrom.description) - \(launchTimeTo.description)"
    }
    
    var startLaunchTimeInterval: TimeInterval? {
        guard let launchTimeFrom = lunchTimeFrom else {
            return nil
        }
        let seconds = Int64(launchTimeFrom.hour * 60 * 60 + launchTimeFrom.minute * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
    var finishLaunchTimeInterval: TimeInterval?  {
        guard let launchTimeTo = lunchTimeTo else {
            return nil
        }
        let seconds = Int64(launchTimeTo.hour * 60 * 60 + launchTimeTo.minute * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
    var opensTimeInterval: TimeInterval {
        let seconds = Int64(from.hour * 60 * 60 + from.minute * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
    var closesTimeInterval: TimeInterval {
        let seconds = Int64(to.hour * 60 * 60 + to.minute * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
}

extension WorkingDayViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(dayOfWeek.rawValue)
    }
}
