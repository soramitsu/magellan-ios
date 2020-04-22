//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import GoogleMaps

protocol MapViewProtocol: class, ControllerBackedProtocol, Containable, AutoMockable {
    var presenter: MapPresenterProtocol { get }
    var zoom: Int { get }
    var coordinatesHash: String { get }
    
    func show(place: PlaceViewModel)
    func reloadData()
    
}

protocol MapPresenterProtocol: AnyObject {
    var mapView: MapViewProtocol? { get set }
    var categories: [Category] { get }
    var places: [PlaceViewModel] { get }

    func showDetails(place: PlaceViewModel)
    func loadPlaces()
}
