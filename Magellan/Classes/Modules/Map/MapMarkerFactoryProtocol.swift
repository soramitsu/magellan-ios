//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit
import GoogleMaps

protocol MapMarkerFactoryProtocol {
    
    func marker(for place: PlaceViewModel) -> GMSMarker
    func image(for category: String) -> UIImage?
    
}

final class MapMarkerDefaultFactory: MapMarkerFactoryProtocol {
    
    func marker(for place: PlaceViewModel) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = place.name
        marker.snippet = place.category
        marker.position = place.coordinates
        if let iconImage = image(for: place.category) {
            let iconView = UIImageView(image: iconImage)
            iconView.contentMode = .scaleAspectFit
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            marker.iconView = iconView
        }
        marker.userData = place
        
        return marker
    }
    
    func image(for category: String) -> UIImage? {
        if let image = UIImage(named: category, in: Bundle.frameworkBundle, compatibleWith: nil) {
            return image
        }
        return UIImage(named: "map_other", in: Bundle.frameworkBundle, compatibleWith: nil)
    }
    
}
