//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit
import GoogleMaps

protocol MapMarkerFactoryProtocol {
    
    func marker(place viewModel: PlaceViewModel) -> GMSMarker
    func image(for category: String) -> UIImage?
    
    func marker(cluster viewModel: ClusterViewModel, font: UIFont) -> GMSMarker
}

final class MapMarkerDefaultFactory: MapMarkerFactoryProtocol {
    
    func marker(place viewModel: PlaceViewModel) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = viewModel.name
        marker.snippet = viewModel.category
        marker.position = viewModel.position
        if let iconImage = image(for: viewModel.category) {
            let iconView = UIImageView(image: iconImage)
            iconView.contentMode = .scaleAspectFit
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            marker.iconView = iconView
        }
        marker.userData = viewModel
        
        return marker
    }
    
    func image(for category: String) -> UIImage? {
        guard let image = UIImage(named: "map_\(category.lowercased())", in: Bundle.frameworkBundle, compatibleWith: nil) else {
            return UIImage(named: "map_other", in: Bundle.frameworkBundle, compatibleWith: nil)!
        }
        
        return image
    }
    
    func marker(cluster viewModel: ClusterViewModel, font: UIFont) -> GMSMarker {
        let countLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        countLabel.text = viewModel.title
        countLabel.font = font
        countLabel.textColor = .gray
        countLabel.backgroundColor = UIColor(red: 0.176, green: 0.161, blue: 0.149, alpha: 0.8)
        countLabel.textAlignment = .center
        countLabel.layer.cornerRadius = 32 / 2
        countLabel.layer.masksToBounds = true
        countLabel.textColor = .white
        
        let marker = GMSMarker()
        marker.userData = viewModel
        marker.iconView = countLabel
        marker.position = viewModel.coordinates.coreLocationCoordinates
        
        return marker
    }
}
