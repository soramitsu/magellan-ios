//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit
import GoogleMaps

protocol Selectable: UIView {
    func setSelected(_ selected: Bool, animated: Bool)
}

protocol MapMarkerFactoryProtocol {
    
    func marker(place viewModel: PlaceViewModel, selected: Bool) -> GMSMarker
    func image(for category: String) -> UIImage
    
    func marker(cluster viewModel: ClusterViewModel, font: UIFont) -> GMSMarker
}

final class MapMarkerDefaultFactory: MapMarkerFactoryProtocol {
    
    private func iconView(for viewModel: PlaceViewModel) -> Selectable {
        let image = self.image(for: viewModel.type)
        return PlaceIconView(image: image)
    }
    
    func marker(place viewModel: PlaceViewModel, selected: Bool) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = viewModel.position
        let iconView = self.iconView(for: viewModel)
        iconView.setSelected(selected, animated: false)
        marker.iconView = iconView
        marker.userData = viewModel
        marker.groundAnchor = CGPoint(x: 0.5, y: 1)
        
        return marker
    }
    
    func image(for category: String) -> UIImage {
        guard let image = UIImage(named: "template_\(category.lowercased())", in: Bundle.frameworkBundle, compatibleWith: nil) else {
            return UIImage(named: "template_other", in: Bundle.frameworkBundle, compatibleWith: nil)!
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
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        return marker
    }
}
