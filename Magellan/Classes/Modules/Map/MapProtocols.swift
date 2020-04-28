//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import GoogleMaps

protocol MapViewProtocol: class, ControllerBackedProtocol, Containable, Loadable, AutoMockable {
    var presenter: MapPresenterProtocol { get }
    
    func show(place: PlaceViewModel)
    func reloadData()
    
}

protocol MapPresenterProtocol: MapListOutputProtocol, AutoMockable {
    
    var view: MapViewProtocol? { get set }
    var coordinator: MapCoordinatorProtocol? { get set }
    var output: MapOutputProtocol? { get set }
    var categories: [PlaceCategory] { get }
    var places: [PlaceViewModel] { get }
    var position: Coordinates { get }

    func showDetails(place: PlaceViewModel)
    func loadCategories()
}

protocol MapCoordinatorProtocol: AnyObject, AutoMockable {
    func showDetails(for placeInfo: PlaceInfo)
}

protocol MapOutputProtocol: AnyObject {
    func didUpdate(categories: [PlaceCategory])
    func didUpdate(places: [PlaceViewModel])
}

