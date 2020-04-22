//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListPresenter: MapListPresenterProtocol {
    var view: MapListViewProtocol?
    var delegate: MapListCoordinatorProtocol?
    
    var categories: [Category] = [] {
        didSet {
            view?.setCategories(categories)
        }
    }
    
    private let service: MagellanServicePrototcol
    private var completionQueue: DispatchQueue {
        return DispatchQueue.main
    }
    
    init(service: MagellanServicePrototcol) {
        self.service = service
    }
    
    func reloadData() {
        service.getCategories(runCompletionIn: completionQueue) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let items):
                self.categories = items
            case .failure(let error):
                print(error)
                self.categories = []
            }
            
        }
    }
}
