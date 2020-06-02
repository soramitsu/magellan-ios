/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Schedule: Codable, Equatable {
    
    let open24: Bool
    let workDays: [WorkingDay]?
    
}

struct WorkingDay: WorkingStatusProtocol, Codable, Equatable {
    
    struct Time: Codable, Equatable {
        let hour: Int
        let minutes: Int
        
        var description: String {
            let minutesValue = minutes < 10 ? "0\(minutes)" : String(minutes)
            return "\(hour):\(minutesValue)"
        }
    }
    
    enum Day: String, Codable {
        case Monday = "MONDAY"
        case Tuesday = "THURSDAY"
        case Wednesday = "WEDNESDAY"
        case Thursday = "THRUSDAY"
        case Friday = "FRIDAY"
        case Saturday = "SATURDAY"
        case Sunday = "SUNDAY"
        
        var numberOfWeek: Int {
            switch self {
            case .Monday:
                return 1
            case .Tuesday:
                return 2
            case .Wednesday:
                return 3
            case .Thursday:
                return 4
            case .Friday:
                return 5
            case .Saturday:
                return 6
            case .Sunday:
                return 0
            }
        }
    }
    
    let day: Day
    let from: Time
    let to: Time
    let launchTimeFrom: Time?
    let launchTimeTo: Time?
    
    var currentDate: Date {
        return Date()
    }

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
        return launchTimeFrom?.description
    }
    var finishLaunchTime: String? {
        return launchTimeTo?.description
    }
    
    var launchHours: String? {
        guard let launchTimeFrom = launchTimeFrom,
            let launchTimeTo = launchTimeTo else {
                return nil
        }
        return "\(launchTimeFrom.description) - \(launchTimeTo.description)"
    }
    
    var startLaunchTimeInterval: TimeInterval? {
        guard let launchTimeFrom = launchTimeFrom else {
            return nil
        }
        let seconds = Int64(launchTimeFrom.hour * 60 * 60 + launchTimeFrom.minutes * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
    var finishLaunchTimeInterval: TimeInterval?  {
        guard let launchTimeTo = launchTimeTo else {
            return nil
        }
        let seconds = Int64(launchTimeTo.hour * 60 * 60 + launchTimeTo.minutes * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
    var opensTimeInterval: TimeInterval {
        let seconds = Int64(from.hour * 60 * 60 + from.minutes * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
    var closesTimeInterval: TimeInterval {
        let seconds = Int64(to.hour * 60 * 60 + to.minutes * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
}

struct PlaceInfo: Coordinated {
    
    let id: Int
    let name: String
    let type: String
    let coordinates: Coordinates
    let address: String
    let phoneNumber: String
    let region: String
    let website: String
    let facebook: String
    let logoUuid: String
    let promoImageUuid: String
    let distance: String
    let workSchedule : Schedule
}

extension PlaceInfo {
    
    var currentWorkingDay: WorkingDay? {
        let weekDayNumber = Calendar.current.component(.weekday, from: Date()) - 1
        return workSchedule
            .workDays?
            .first(where: { $0.day.numberOfWeek == weekDayNumber })
    }
    
    var isOpen: Bool {
        
        if workSchedule.open24 {
            return true
        }
        
        if let currentWorkingDay = currentWorkingDay {
            return currentWorkingDay.isOpen
        }
        
        return false
        
    }
    
    var workingStatus: String {
        if workSchedule.open24 {
            return L10n.Location.Details.Status.open
        }
        
        if let currentWorkingDay = currentWorkingDay {
            return currentWorkingDay.status
        }
        
        return L10n.Location.Details.Status.closed
    }
}

extension PlaceInfo: Codable { }
extension PlaceInfo: Equatable { }
