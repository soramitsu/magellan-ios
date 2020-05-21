//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import CoreLocation

public struct Coordinates: Codable, Equatable {
    let lat: Double
    let lon: Double
}

extension Coordinates {
    var location: CLLocation {
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    var coreLocationCoordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

extension CLLocationCoordinate2D: Coordinated {
    var coordinates: Coordinates {
        return Coordinates(lat: latitude, lon: longitude)
    }
}
