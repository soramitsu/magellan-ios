/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol MapListViewProtocol: ControllerBackedProtocol, AutoMockable {
    var presenter: MapListPresenterProtocol { get }
    func reloadPlaces()
    func reloadCategories()
    func showErrorState(_ retryClosure: @escaping () -> Void)
}

protocol MapListPresenterProtocol: MapOutputProtocol, AutoMockable {
    var places: [PlaceViewModel] { get }
    var view: MapListViewProtocol? { get set }
    var output: MapListOutputProtocol? { get set }
    var delegate: MapListPresenterDelegate? { get set }
    
    func showDetails(place: PlaceViewModel)
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
    func search(with text: String)
    func reset()
    
}

