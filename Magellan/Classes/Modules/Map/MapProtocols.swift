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

protocol MapPresenterProtocol: MapInputProtocol, AutoMockable {
    
    var view: MapViewProtocol? { get set }
    var coordinator: MapCoordinatorProtocol? { get set }
    var listInput: MapListInputProtocol? { get set }
    var categories: [PlaceCategory] { get }
    var places: [PlaceViewModel] { get }
    var position: Coordinates { get }

    func showDetails(place: PlaceViewModel)
    func loadCategories()
}

protocol MapCoordinatorProtocol: AnyObject, AutoMockable {
    func showDetails(for placeInfo: PlaceInfo)
}

protocol MapInputProtocol: AnyObject {
    
    func select(place: PlaceViewModel)
    func select(category: String)
    func search(with text: String)
    func reset()
    
}
