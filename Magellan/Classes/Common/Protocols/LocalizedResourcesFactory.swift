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
    let places: String = L10n.MainViewController.title
    let searchPlaceholder: String = L10n.MapListView.Search.placeholder
    let nearbyPlaces: String = L10n.MapListView.nearbyplaces
    let information: String = L10n.Location.Details.information
    let phoneNumber: String = L10n.Location.Details.phone
    let website: String = L10n.Location.Details.website
    let faceBook: String = L10n.Location.Details.fb
    let email: String = L10n.Location.Details.email
    let address: String = L10n.Location.Details.address
    let workingHours: String = L10n.Location.Details.workingHours
    let open: String = L10n.Location.Details.Status.open
    let closed: String = L10n.Location.Details.Status.closed
    let openTill: String = L10n.Location.Details.Status.openTill
    let closedTill: String = L10n.Location.Details.Status.closedTill
    let filter: String = L10n.Filter.title
    let reset: String = L10n.Filter.reset
    
}
