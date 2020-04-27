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
    
    let day: String
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
        return TimeInterval(integerLiteral: Int64(seconds))
    }
    
}

struct PlaceInfo {
    
    let id: Int
    let name: String
    let type: String
    let coordinates: Coordinates
    let address: String
    let phoneNumber: String
    let website: String
    let facebook: String
    let logoUuid: String
    let promoImageUuid: String
    let distance: String
    let workingSchdule : Schedule
}

extension PlaceInfo {
    
    var currentWorkingDay: WorkingDay? {
        return workingSchdule
            .workingDays?
            .first(where: { $0.day.lowercased() == Date().currentDay.lowercased() })
    }
    
    var isOpen: Bool {
        
        if workingSchdule.opens24 {
            return true
        }
        
        if let currentWorkingDay = currentWorkingDay {
            return currentWorkingDay.isOpen
        }
        
        return false
        
    }
    
    var workingStatus: String {
        if workingSchdule.opens24 {
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
