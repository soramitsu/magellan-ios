//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import CoreLocation
import GoogleMapsUtils

class PlaceViewModel: NSObject, Coordinated {
    
    let place: Place
    let locale: Locale
    var currentLocation: CLLocation?
    
    var id: String {
        return place.id
    }
    
    var name: String {
        return place.name
    }
    
    var category: String {
        guard locale.isKm,
            let khmerType = place.khmerType else {
                return place.type
        }
        return khmerType
    }
    
    var distance: Double {
        guard let currentLocation = currentLocation else {
            return 0.0
        }
        
        return place.coordinates.location.distance(from: currentLocation) / 1000
    }
    
    var coordinates: Coordinates {
        return place.coordinates
    }
    
    init(place: Place, locale: Locale) {
        self.place = place
        self.locale = locale
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? PlaceViewModel {
            return self.place == rhs.place
        }
        return false
    }
    
}

extension PlaceViewModel: GMUClusterItem {
    var position: CLLocationCoordinate2D {
        return place.coordinates.coreLocationCoordinates
    }
}

