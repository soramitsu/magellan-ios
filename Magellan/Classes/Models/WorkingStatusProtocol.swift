//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol WorkingStatusProtocol {
    var currentDate: Date { get }
    
    var opensTime: String { get }
    var closesTime: String { get }
    var workingHours: String { get }
    
    var opensTimeInterval: TimeInterval { get }
    var closesTimeInterval: TimeInterval  { get }
    var intervalFromDayBegins: TimeInterval  { get }
    
    var isOpen: Bool  { get }
    var status: String  { get }
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
        if intervalFromDayBegins >= opensTimeInterval
            && intervalFromDayBegins < closesTimeInterval {
            return true
        }
        
        return false
    }
    
    var status: String {
        if intervalFromDayBegins == 0 {
            return ""
        }
        
        if intervalFromDayBegins >= opensTimeInterval
            && intervalFromDayBegins < closesTimeInterval {
            return L10n.Location.Details.Status.openTill(closesTime)
        } else if intervalFromDayBegins < opensTimeInterval {
            return L10n.Location.Details.Status.closedTill(opensTime)
        } else if intervalFromDayBegins > closesTimeInterval {
            return L10n.Location.Details.Status.closed
        }
        
        return workingHours
    }
}
