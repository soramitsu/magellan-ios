/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation


protocol LocationDetailsPresenterDelegate: class, AutoMockable {
    
    func dismiss()
    
}


protocol LocationDetailsPresenterProtocol: class {

    var view: LocationDetailsViewProtocol? { get set }
    var delegate: LocationDetailsPresenterDelegate? { get set }
    var items: [LocationSectionViewModel] { get }
    
    func dismiss()
    func viewDidLoad()
}


protocol LocationDetailsViewProtocol: class, ControllerBackedProtocol {
    
    var presenter: LocationDetailsPresenterProtocol { get set }
    
    func reload()
    
    func reload(at indexPaths:[IndexPath])
}
