//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public final class ReviewAssembly {
    
    public static func assembly(with resolver: MagellanNetworkResolverProtocol) -> UIViewController {
        
        let operationFactory = MiddlewareOperationFactory(networkResolver: resolver)
        let service = MagellanService(operationFactory: operationFactory)
        let placeProvider = DemoPlaceProvider(service: service)
        let dataSource = PlaceReviewDataSource(style: DefaultMagellanStyle())
        let model = ReviewModel(placeProvider: placeProvider, dataSource: dataSource)
        let style = DefaultMagellanStyle()
        let listController = ListViewController(model: model, style: style)
        let modalController = ModalViewController(rootViewController: listController)
        
        dataSource.view = listController
        
        return UINavigationController(rootViewController: modalController)
    }
    
}
