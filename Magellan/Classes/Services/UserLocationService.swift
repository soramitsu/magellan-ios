//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import CoreLocation

protocol UserLocationServiceDelegate: AnyObject {
    func userLocationDidUpdate()
}

protocol UserLocationServiceProtocol: AutoMockable {
    var currentLocation: Coordinates? { get }
    var delegaet: UserLocationServiceDelegate? { get set }
}

final class UserLocationService: NSObject, UserLocationServiceProtocol {
    var currentLocation: Coordinates?
    let locationManager: CLLocationManager
    weak var delegaet: UserLocationServiceDelegate?
    
    init(distanceFilter: Double) {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = distanceFilter
        locationManager.startUpdatingLocation()
    }
}


extension UserLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            currentLocation = Coordinates(lat: location.coordinate.latitude,
                                          lon: location.coordinate.longitude)
            delegaet?.userLocationDidUpdate()
        }
    }
    
}
