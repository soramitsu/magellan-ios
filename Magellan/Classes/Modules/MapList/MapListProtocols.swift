/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol MapListViewProtocol: ControllerBackedProtocol {
    var presenter: MapListPresenterProtocol { get }
    func reloadData()
}

protocol MapListPresenterProtocol: AnyObject {
    var categories: [Category] { get }
    var places: [PlaceViewModel] { get }
    var listView: MapListViewProtocol? { get set }
    
    func showDetails(place: PlaceViewModel)
    func select(category: String)
    func serach(with text: String)
}
