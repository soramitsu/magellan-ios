/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol ResolverProtocol {
    
    var style: MagellanStyleProtocol { get }
    var phoneFormatter: PhoneFormatterProtocol? { get set }
    var errorViewFactory: ErrorViewFactoryProtocol? { get set }
    
    var distanceFilter: Double { get set }
    var defaultCoordinate: Coordinates { get set }
    
    var networkOperationFactory: MiddlewareOperationFactoryProtocol { get }
    var markerFactory: MapMarkerFactoryProtocol? { get set }
    
    var localizationResourcesFactory: LocalizedResourcesFactoryProtocol { get }
}

extension ResolverProtocol {
    var networkService: MagellanServicePrototcol {
        return MagellanService(operationFactory: networkOperationFactory)
    }
}

final class Resolver: ResolverProtocol {
    
    var style: MagellanStyleProtocol
    var phoneFormatter: PhoneFormatterProtocol?
    var errorViewFactory: ErrorViewFactoryProtocol?
    
    var distanceFilter: Double = 50
    var defaultCoordinate: Coordinates = Coordinates(lat: 11.5796669, lon: 104.7501013)
    
    let networkOperationFactory: MiddlewareOperationFactoryProtocol
    let localizationResourcesFactory: LocalizedResourcesFactoryProtocol
    var markerFactory: MapMarkerFactoryProtocol?
    
    init(networkOperationFactory: MiddlewareOperationFactoryProtocol,
         style: MagellanStyleProtocol,
         localizationResourcesFactory: LocalizedResourcesFactoryProtocol) {
        self.networkOperationFactory = networkOperationFactory
        self.style = style
        self.localizationResourcesFactory = localizationResourcesFactory
    }
    
}
