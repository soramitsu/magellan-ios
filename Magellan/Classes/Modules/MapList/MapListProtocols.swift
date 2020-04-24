/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol MapListViewProtocol: ControllerBackedProtocol, AutoMockable {
    var presenter: MapListPresenterProtocol { get }
    func reloadData()
}

protocol MapListPresenterProtocol: MapListInputProtocol, AutoMockable {
    var categories: [PlaceCategory] { get }
    var places: [PlaceViewModel] { get }
    var view: MapListViewProtocol? { get set }
    var mapInput: MapInputProtocol? { get set }
    
    func showDetails(place: PlaceViewModel)
    func select(category: String)
    func search(with text: String)
}

protocol MapListInputProtocol: AnyObject {
    func set(categories: [PlaceCategory], places: [PlaceViewModel])
}
