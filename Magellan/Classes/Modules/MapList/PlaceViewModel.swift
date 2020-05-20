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
    var currentLocation: CLLocation?
    
    var id: Int {
        return place.id
    }
    
    var name: String {
        return place.name
    }
    
    var category: String {
        return place.type
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
    
    init(place: Place) {
        self.place = place
    }
    
}

extension PlaceViewModel: GMUClusterItem {
    var position: CLLocationCoordinate2D {
        return place.coordinates.coreLocationCoordinates
    }
}

