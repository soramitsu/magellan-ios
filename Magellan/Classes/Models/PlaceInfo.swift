/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Schedule: Codable, Equatable {
    
    let opens24: Bool
    let workingDays: [WorkingDay]?
    
}

struct WorkingDay: Codable, Equatable {
    
    struct Time: Codable, Equatable {
        let hour: Int
        let minutes: Int
    }
    
    let day: String
    let opens: Time
    let closes: Time
    
    var workingHours: String {
        let opensMinutes = opens.minutes < 10 ? "0\(opens.minutes)" : "\(opens.minutes)"
        let closesMinutes = closes.minutes < 10 ? "0\(closes.minutes)" : "\(closes.minutes)"
        return "\(opens.hour):\(opensMinutes) - \(closes.hour):\(closesMinutes)"
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

extension PlaceInfo: Codable { }
extension PlaceInfo: Equatable { }
