/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Schedule: Codable, Equatable {
    
    let opens24: Bool
    let workingDays: [WorkingDay]?
    
}

struct WorkingDay: WorkingStatusProtocol, Codable, Equatable {
    
    struct Time: Codable, Equatable {
        let hour: Int
        let minutes: Int
    }
    
    enum Day: Int, Codable {
        case Monday = 1
        case Tuesday = 2
        case Wednesday = 3
        case Thursday = 4
        case Friday = 5
        case Saturday = 6
        case Sunday = 0
    }
    
    let day: Day
    let opens: Time
    let closes: Time
    
    var currentDate: Date {
        return Date()
    }
    
    var opensMinutes: String {
        opens.minutes < 10 ? "0\(opens.minutes)" : "\(opens.minutes)"
    }
    
    var closesMinutes: String {
        closes.minutes < 10 ? "0\(closes.minutes)" : "\(closes.minutes)"
    }
    
    var opensTime: String {
        return "\(opens.hour):\(opensMinutes)"
    }
    var closesTime: String {
        return "\(closes.hour):\(closesMinutes)"
    }
    
    var workingHours: String {
        return "\(opens.hour):\(opensMinutes) - \(closes.hour):\(closesMinutes)"
    }
    
    var opensTimeInterval: TimeInterval {
        let seconds = Int64(opens.hour * 60 * 60 + opens.minutes * 60)
        return TimeInterval(integerLiteral: seconds)
    }
    
    var closesTimeInterval: TimeInterval {
        let seconds = Int64(closes.hour * 60 * 60 + closes.minutes * 60)
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
    let workingSchedule : Schedule
}

extension PlaceInfo {
    
    var currentWorkingDay: WorkingDay? {
        let weekDayNumber = Calendar.current.component(.weekday, from: Date()) - 1
        return workingSchedule
            .workingDays?
            .first(where: { $0.day.rawValue == weekDayNumber })
    }
    
    var isOpen: Bool {
        
        if workingSchedule.opens24 {
            return true
        }
        
        if let currentWorkingDay = currentWorkingDay {
            return currentWorkingDay.isOpen
        }
        
        return false
        
    }
    
    var workingStatus: String {
        if workingSchedule.opens24 {
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
