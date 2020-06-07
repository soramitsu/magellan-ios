//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation


public protocol LocalizedResorcesFactoryProtocol {
    
    var notificationName: String { get }
    
    var places: String { get }
    var searchPlaceholder: String { get }
    var nearbyPlaces: String { get }
    
    var information: String { get }
    var phoneNumber: String { get }
    var website: String { get }
    var faceBook: String { get }
    var email: String { get }
    var address: String { get }
    var workingHours: String { get }
    
    var open: String { get }
    var closed: String { get }
    var openTill: String { get }
    var closedTill: String { get }
    
    var filter: String { get }
    var reset: String { get }

}

struct DefaultLocalizedResorcesFactory: LocalizedResorcesFactoryProtocol {
    
    let notificationName: String = "LanguageChangeNotification"
    let places: String = "Places";
    let searchPlaceholder: String = "Search by name...";
    let nearbyPlaces: String = "Nearby places";
    let information: String = "Information";
    let phoneNumber: String = "Phone number";
    let website: String = "Website";
    let faceBook: String = "FB";
    let email: String = "E-mail";
    let address: String = "Address";
    let workingHours: String = "Working hours";
    let open: String = "Open";
    let closed: String = "Closed";
    let openTill: String = "Open till";
    let closedTill: String = "Closed till";
    let filter: String = "Filter";
    let reset: String = "Reset";

}
