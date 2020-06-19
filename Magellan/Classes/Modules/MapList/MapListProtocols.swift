/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

enum MapListModuleState {
    case normal
    case search
    case error
}

protocol MapListViewProtocol: ControllerBackedProtocol, AutoMockable {
    var presenter: MapListPresenterProtocol { get }
    func reloadPlaces()
    func showErrorState(_ retryClosure: @escaping () -> Void)
    func set(placeholder: String)
    func set(loading: Bool)
}

protocol MapListPresenterProtocol: MapOutputProtocol, AutoMockable {
    var places: [PlaceViewModel] { get }
    var view: MapListViewProtocol? { get set }
    var output: MapListOutputProtocol? { get set }
    var delegate: MapListPresenterDelegate? { get set }
    
    func showDetails(place: PlaceViewModel)
    func search(with text: String?)
    
    func dismiss()
    func expand()
    func viewDidLoad()
    func finishSearch()
}

protocol MapListPresenterDelegate: AnyObject {
    
    func collapseList()
    func expandList()
    
}

protocol MapListOutputProtocol: AnyObject {
    
    func moduleChange(state: MapListModuleState)
    func select(place: PlaceViewModel)
    func search(with text: String?)
    func reset()
    
}

