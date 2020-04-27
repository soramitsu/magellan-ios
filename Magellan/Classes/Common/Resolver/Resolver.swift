/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol ResolverProtocol {
    
    var mapListStyle: MapListViewStyleProtocol? { get set }
    var locationDetailsViewStyle: LocationDetailsViewStyleProtocol? { get set }
    var locationDetailsTableHelperFactory: ((PlaceInfo) -> MapDetailTableHelperProtocol)? { get set }
    
    var networkOperationFactory: MiddlewareOperationFactoryProtocol { get }
    var markerFactory: MapMarkerFactoryProtocol? { get set }
}

extension ResolverProtocol {
    var networkService: MagellanServicePrototcol {
        return MagellanService(operationFactory: networkOperationFactory)
    }
}

final class Resolver: ResolverProtocol {
    
    var mapListStyle: MapListViewStyleProtocol?
    var locationDetailsViewStyle: LocationDetailsViewStyleProtocol?
    var locationDetailsTableHelperFactory: ((PlaceInfo) -> MapDetailTableHelperProtocol)?
    
    let networkOperationFactory: MiddlewareOperationFactoryProtocol
    var markerFactory: MapMarkerFactoryProtocol?
    
    init(networkOperationFactory: MiddlewareOperationFactoryProtocol) {
        self.networkOperationFactory = networkOperationFactory
    }
    
}
