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
        return workingDay.lunchTimeFrom
    }
    
    var lunchTimeTo: Time? {
        return workingDay.lunchTimeTo
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
    
    var startLunchTime: String? {
        return lunchTimeFrom?.description
    }
    var finishLunchTime: String? {
        return lunchTimeTo?.description
    }
    
    var lunchHours: String? {
        guard let lunchTimeFrom = lunchTimeFrom,
            let lunchTimeTo = lunchTimeTo else {
                return nil
        }
        return "\(lunchTimeFrom.description) - \(lunchTimeTo.description)"
    }
    
    var startLunchTimeInterval: TimeInterval? {
        guard let lunchTimeFrom = lunchTimeFrom else {
            return nil
        }
        let seconds = Int64(lunchTimeFrom.hour * 60 * 60 + lunchTimeFrom.minute * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
    var finishLunchTimeInterval: TimeInterval?  {
        guard let lunchTimeTo = lunchTimeTo else {
            return nil
        }
        let seconds = Int64(lunchTimeTo.hour * 60 * 60 + lunchTimeTo.minute * 60)
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
