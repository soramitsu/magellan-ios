//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation


public protocol LocalizedResourcesFactoryProtocol {
    
    var notificationName: String { get }
    var currentLocale: String { get }
    
    var places: String { get }
    var searchPlaceholder: String { get }
    var nearbyPlaces: String { get }
    
    var information: String { get }
    var phoneNumber: String { get }
    var website: String { get }
    var facebook: String { get }
    var email: String { get }
    var address: String { get }
    var workingHours: String { get }

    var allTimeWorks: String { get }
    var open: String { get}
    var closed: String { get}
    var until: String { get}
    var opens: String { get}
    var closes: String { get}
    var reopens: String { get}
    
    var filter: String { get }
    var reset: String { get }

}

internal extension LocalizedResourcesFactoryProtocol {
    var locale: Locale {
        return Locale(rawValue: currentLocale) ?? Locale.en
    }
}

struct DefaultLocalizedResorcesFactory: LocalizedResourcesFactoryProtocol {

    let notificationName: String = "LanguageChangeNotification"
    var currentLocale: String { return "en" }
    let places: String = "Places";
    let searchPlaceholder: String = "Search by name...";
    let nearbyPlaces: String = "Nearby places";
    let information: String = "Information";
    let phoneNumber: String = "Phone number";
    let website: String = "Website";
    let facebook: String = "FB";
    let email: String = "E-mail";
    let address: String = "Address";
    let workingHours: String = "Working hours";
    let allTimeWorks: String = "Open 24 hours"
    let open: String = "Open";
    let closed: String = "Closed";
    let openTill: String = "Open till";
    let closedTill: String = "Closed till";
    let filter: String = "Filter";
    let reset: String = "Reset";
    let until: String = "until"
    let opens: String = "opens"
    let closes: String = "closes"
    let reopens: String = "reopens"

}
