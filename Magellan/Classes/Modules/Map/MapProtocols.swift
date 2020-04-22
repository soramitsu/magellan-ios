//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

protocol MapViewProtocol: class, ControllerBackedProtocol, Containable {
    var presenter: MapPresenterProtocol { get }
}

protocol MapPresenterProtocol {
    var view: MapViewProtocol? { get set }
    var delegate: MapCoordinatorProtocol? { get set }
}

protocol MapCoordinatorProtocol: CoordinatorProtocol {
    
}
