//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct WorkingStatusResources {
    let open: String
    let closed: String
    let until: String
    let opens: String
    let closes: String
    let reopens: String
}

protocol WorkingStatusProtocol: Codable {

    var day: String? { get }
    var currentDate: Date { get }
    
    var opensTime: String { get }
    var closesTime: String { get }
    var workingHours: String { get }
    
    var startLunchTime: String? { get }
    var finishLunchTime: String? { get }
    var lunchHours: String? { get }
    
    var opensTimeInterval: TimeInterval { get }
    var closesTimeInterval: TimeInterval  { get }
    
    var startLunchTimeInterval: TimeInterval? { get }
    var finishLunchTimeInterval: TimeInterval?  { get }
    var intervalFromDayBegins: TimeInterval  { get }
    
    var isOpen: Bool  { get }
    
    func status(with resources: WorkingStatusResources, nextWorkingDay: WorkingStatusProtocol?) -> String?
}

fileprivate enum Status {
    case open
    case closed
    case beforeOpening
    case beforeLunchTime
    case lunchTime

    static func status(with intervalFromDayBegins: TimeInterval,
         opens: TimeInterval,
         closes: TimeInterval,
         startLunch: TimeInterval?,
         finishLunch: TimeInterval?) -> Status {
        if intervalFromDayBegins < opens {
            return .beforeOpening
        }

        if let startLunch = startLunch,
            intervalFromDayBegins < startLunch {
            return .beforeLunchTime
        }

        if let finishLunch = finishLunch,
            intervalFromDayBegins < finishLunch {
            return .lunchTime
        }

        if intervalFromDayBegins < closes {
            return .open
        }

        return .closed
    }

    var isOpen: Bool {
        switch self {
        case .beforeOpening:
            return false
        case .open:
            return true
        case .closed:
            return false
        case .beforeLunchTime:
            return true
        case .lunchTime:
            return false
        }
    }
}

extension WorkingStatusProtocol {
    
    var intervalFromDayBegins: TimeInterval {
        
        var startOfDay = Calendar.current.dateComponents([.hour, .minute], from: currentDate)
        guard let hour = startOfDay.hour,
            let minute = startOfDay.minute else {
                return 0
        }
        let seconds = Int64(hour * 60 * 60 + minute * 60)
        return TimeInterval(seconds)
    }
    
    var isOpen: Bool {
        let status = Status.status(with: intervalFromDayBegins,
                                   opens: opensTimeInterval,
                                   closes: closesTimeInterval,
                                   startLunch: startLunchTimeInterval,
                                   finishLunch: finishLunchTimeInterval)
        
        return status.isOpen
    }
    
    func status(with resources: WorkingStatusResources, nextWorkingDay: WorkingStatusProtocol?) -> String? {
        if intervalFromDayBegins == 0 {
            return ""
        }

        let status = Status.status(with: intervalFromDayBegins,
                                   opens: opensTimeInterval,
                                   closes: closesTimeInterval,
                                   startLunch: startLunchTimeInterval,
                                   finishLunch: finishLunchTimeInterval)
        switch status {
        case .beforeOpening:
            return "\(resources.opens) \(opensTime)"
        case .open:
            return "\(resources.until) \(closesTime)"
        case .closed:
            guard let nextWorkingDay = nextWorkingDay,
                let nextDay = nextWorkingDay.day else {
                return nil
            }
            return "\(resources.opens) \(nextWorkingDay.opensTime) \(nextDay)"
        case .beforeLunchTime:
            guard let startLunchTime = startLunchTime,
                let finishLunchTime = finishLunchTime else {
                return ""
            }
            return "\(resources.closes) \(startLunchTime), \(resources.reopens) \(finishLunchTime)"
        case .lunchTime:
            guard let finishLunchTime = finishLunchTime else {
                return ""
            }
            return "\(resources.opens) \(finishLunchTime)"
        }
        return workingHours
    }

    private func time(from timeInterval: TimeInterval) -> String {
        let hours = timeInterval / 3600
        let minutes = (timeInterval - hours * 60) / 60
        return "\(hours):\(minutes)"
    }


}
