//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MapListAssembly {
    
    static func assembly(with resolver: ResolverProtocol) -> UIViewController {
        let service = MagellanService(operationFactory: resolver.networkOperationFactory)
        let presenter = MapListPresenter(service: service)
        let view = MapListViewController(presenter: presenter)
        
        presenter.view = view
        
        return view
    }
    
}
