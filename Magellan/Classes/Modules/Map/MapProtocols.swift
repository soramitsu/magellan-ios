//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import GoogleMaps

protocol MapViewProtocol: class, ControllerBackedProtocol, Containable, Loadable, AutoMockable {
    var presenter: MapPresenterProtocol { get }

    func setButtons(hidden: Bool)
    func setFilterButton(hidden: Bool)
    func updateSelection()
    func reloadData()
}

protocol MapPresenterProtocol: MapListOutputProtocol, AutoMockable {
    
    var view: MapViewProtocol? { get }
    var coordinator: MapCoordinatorProtocol? { get set }
    var output: MapOutputProtocol? { get set }
    var categories: [PlaceCategory] { get }
    var places: [PlaceViewModel] { get }
    var clusters: [ClusterViewModel] { get }
    var position: Coordinates { get }
    var myLocation: Coordinates? { get }
    var requestDelay: TimeInterval { get }
    var selectedPlace: PlaceViewModel? { get }

    func showDetails(place: PlaceViewModel)
    func loadCategories()
    func loadPlaces(topLeft:Coordinates, bottomRight: Coordinates, zoom: Int)
    func mapCameraDidChange()
    func showFilter()
    func removeSelection()
}

protocol MapCoordinatorProtocol: AnyObject, AutoMockable {
    
    func hideDetailsIfPresented()
    func showDetails(for placeInfo: PlaceInfo)
    func showCategoriesFilter(categories: [PlaceCategory], filter: Set<PlaceCategory>, output: CategoriesFilterOutputProtocol?)
    
}

protocol MapOutputProtocol: AnyObject {
    func didUpdate(places: [PlaceViewModel])
    func loading(_ show: Bool)
}

