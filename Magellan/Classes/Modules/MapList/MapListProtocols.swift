/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol MapListViewProtocol: ControllerBackedProtocol, AutoMockable {
    var presenter: MapListPresenterProtocol { get }
    func reloadPlaces()
    func reloadCategories()
}

protocol MapListPresenterProtocol: MapOutputProtocol, AutoMockable {
    var categories: [PlaceCategory] { get }
    var places: [PlaceViewModel] { get }
    var view: MapListViewProtocol? { get set }
    var output: MapListOutputProtocol? { get set }
    var delegate: MapListPresenterDelegate? { get set }
    
    func showDetails(place: PlaceViewModel)
    func select(category: String)
    func search(with text: String)
    
    func dismiss()
    func expand()
}

protocol MapListPresenterDelegate: AnyObject {
    
    func collapseList()
    func expandList()
    
}

protocol MapListOutputProtocol: AnyObject {
    
    func select(place: PlaceViewModel)
    func select(category: String)
    func search(with text: String)
    func reset()
    
}
