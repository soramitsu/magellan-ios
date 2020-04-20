/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol MapListViewProtocol: ControllerBackedProtocol {
    var presenter: MapListPresenterProtocol { get }
    
    func setCategories(_ categories: [Category])
}

protocol MapListPresenterProtocol {
    var categories: [Category] { get }
    var view: MapListViewProtocol? { get set }
    var delegate: MapListCoordinatorProtocol? { get set }
    
    func reloadData()
}

protocol MapListCoordinatorProtocol {
    func showPlace(_ place: PlaceInfo)
}
