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
    
    var startLaunchTime: String? { get }
    var finishLaunchTime: String? { get }
    var launchHours: String? { get }
    
    var opensTimeInterval: TimeInterval { get }
    var closesTimeInterval: TimeInterval  { get }
    
    var startLaunchTimeInterval: TimeInterval? { get }
    var finishLaunchTimeInterval: TimeInterval?  { get }
    var intervalFromDayBegins: TimeInterval  { get }
    
    var isOpen: Bool  { get }
    
    func status(with resources: WorkingStatusResources, nextWorkingDay: WorkingStatusProtocol?) -> String?
}

fileprivate enum Status {
    case open
    case closed
    case beforeOpening
    case beforeLaunchTime
    case launchTime

    static func status(with intervalFromDayBegins: TimeInterval,
         opens: TimeInterval,
         closes: TimeInterval,
         startLaunch: TimeInterval?,
         finishLaunch: TimeInterval?) -> Status {
        if intervalFromDayBegins < opens {
            return .beforeOpening
        }

        if let startLaunch = startLaunch,
            intervalFromDayBegins < startLaunch {
            return .beforeLaunchTime
        }

        if let finishLaunch = finishLaunch,
            intervalFromDayBegins < finishLaunch {
            return .launchTime
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
        case .beforeLaunchTime:
            return true
        case .launchTime:
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
                                   startLaunch: startLaunchTimeInterval,
                                   finishLaunch: finishLaunchTimeInterval)
        
        return status.isOpen
    }
    
    func status(with resources: WorkingStatusResources, nextWorkingDay: WorkingStatusProtocol?) -> String? {
        if intervalFromDayBegins == 0 {
            return ""
        }

        let status = Status.status(with: intervalFromDayBegins,
                                   opens: opensTimeInterval,
                                   closes: closesTimeInterval,
                                   startLaunch: startLaunchTimeInterval,
                                   finishLaunch: finishLaunchTimeInterval)
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
        case .beforeLaunchTime:
            guard let startLaunchTime = startLaunchTime,
                let finishLaunchTime = finishLaunchTime else {
                return ""
            }
            return "\(resources.closes) \(startLaunchTime), \(resources.reopens) \(finishLaunchTime)"
        case .launchTime:
            guard let finishLaunchTime = finishLaunchTime else {
                return ""
            }
            return "\(resources.opens) \(finishLaunchTime)"
        }
        return workingHours
    }

    private func time(from timeInterval: TimeInterval) -> String {
        let hours = timeInterval / 3600
        let minutes = (timeInterval - hours * 60) / 60
        return "\(hours):\(minutes)"
    }


}
