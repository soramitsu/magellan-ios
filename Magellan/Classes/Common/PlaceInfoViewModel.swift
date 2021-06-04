//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct PlaceInfoViewModel {
    
    let place: PlaceInfo
    let workSchedule: ScheduleViewModel?
    
    var id: String {
        return place.id
    }
    
    var name: String {
        return place.name
    }
    
    var type: String {
        if let type = place.type {
            return type
        } else if let types = place.types {
            return types.eng
        }
        return ""
    }
    
    var khmerType: String? {
        if let khmerType = place.khmerType {
            return khmerType
        } else if let types = place.types {
            return types.khm
        }
        return ""
    }
    
    var coordinates: Coordinates {
        return place.coordinates
    }
    
    var address: String {
        return place.address
    }
    
    var phoneNumber: String? {
        return place.phoneNumber
    }
    
    var region: String? {
        return place.region
    }
    
    var website: String? {
        return place.website
    }
    
    var facebook: String? {
        return place.facebook
    }
    
    var logoUuid: String? {
        return place.logoUuid
    }
    
    var promoImageUuid: String? {
        return place.promoImageUuid
    }
    
    var distance: String? {
        return place.distance
    }
    
    init(place: PlaceInfo, currentDay: Int = Calendar.current.component(.weekday, from: Date()) - 1) {
        self.place = place
        if let schedule = place.workSchedule {
            self.workSchedule = ScheduleViewModel(schedule: schedule, weekDayNumber: currentDay)
        } else {
            self.workSchedule = nil
        }
    }
    
    var isOpen: Bool {
        if workSchedule?.open24 == true {
            return true
        }
        
        if let currentWorkingDay = workSchedule?.currentWorkingDay {
            return currentWorkingDay.isOpen
        }
        
        return false
        
    }
    
    func workingStatus(with resources: WorkingStatusResources) -> String {
        if workSchedule?.open24 == true {
            return resources.open
        }

        if let currentWorkingDay = workSchedule?.currentWorkingDay,
            let status = currentWorkingDay.status(with: resources, nextWorkingDay: workSchedule?.nextWorkingDay) {
            return status
        }
        
        return ""
    }
    
}
