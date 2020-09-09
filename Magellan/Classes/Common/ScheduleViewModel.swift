//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct ScheduleViewModel {
    
    let schedule: Schedule
    let weekDayNumber: Int
    
    var open24: Bool {
        return schedule.open24
    }
    
    let workDays: Set<WorkingDayViewModel>?
    
    var isDaily: Bool {
        guard let workDays = workDays,
            workDays.count == 7,
            let first = workDays.first else {
                return false
        }
        var result = true
        for item in workDays {
            if first.workingHours == item.workingHours
                && first.launchHours == item.launchHours {
                continue
            }
            result = false
            break
        }
        
        return result
    }
    
    var currentWorkingDay: WorkingDayViewModel? {
        return workDays?
            .first(where: { $0.dayOfWeek.numberOfWeek == weekDayNumber })
    }
    
    var nextWorkingDay: WorkingDayViewModel? {
        let nextDayNumber = (weekDayNumber + 1) % 7
        return workDays?
            .first(where: { $0.dayOfWeek.numberOfWeek == nextDayNumber })
    }
    
    init(schedule: Schedule, weekDayNumber: Int) {
        self.schedule = schedule
        self.weekDayNumber = weekDayNumber
        if let workingDays = schedule.workDays {
            self.workDays = Set(workingDays.map { WorkingDayViewModel(workingDay: $0) })
        } else {
            self.workDays = nil
        }
    }
    
    func description(with localizator: LocalizedResourcesFactoryProtocol) -> String? {
        guard let workingHours = currentWorkingDay?.workingHours else {
            return nil
        }
        
        var prefix = isDaily ? localizator.daily : localizator.today
        var scheduleInfo = "\(prefix) \(workingHours)"
        if let lauchHours = currentWorkingDay?.launchHours {
            scheduleInfo += "\n\(localizator.lunchTime) \(lauchHours)"
        }
        return scheduleInfo
    }
    
}
