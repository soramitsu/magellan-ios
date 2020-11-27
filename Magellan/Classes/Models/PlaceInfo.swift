/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Schedule: Codable {
    
    let open24: Bool
    let workDays: Set<WorkingDay>?

}

enum Day: String, Codable {
    case Monday = "MONDAY"
    case Tuesday = "TUESDAY"
    case Wednesday = "WEDNESDAY"
    case Thursday = "THURSDAY"
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

struct Time: Codable, Equatable {
    let hour: Int
    let minute: Int
    
    var description: String {
        let minutesValue = minute < 10 ? "0\(minute)" : String(minute)
        return "\(hour):\(minutesValue)"
    }
}

struct WorkingDay: Codable, Equatable {
    
    let dayOfWeek: Day
    let from: Time
    let to: Time
    let lunchTimeFrom: Time?
    let lunchTimeTo: Time?
    
}

extension WorkingDay: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(dayOfWeek.rawValue)
    }
}

public struct PlaceInfo: Coordinated {
    
    let id: String
    let name: String
    let type: String
    let khmerType: String?
    let coordinates: Coordinates
    let address: String
    let phoneNumber: String?
    let region: String?
    let website: String?
    let facebook: String?
    let logoUuid: String?
    let promoImageUuid: String?
    let distance: String?
    let workSchedule: Schedule?
}

extension PlaceInfo: Codable { }
extension PlaceInfo: Equatable {
    public static func == (lhs: PlaceInfo, rhs: PlaceInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
