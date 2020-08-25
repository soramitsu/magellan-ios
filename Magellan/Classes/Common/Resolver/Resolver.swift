/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol ResolverProtocol {
    
    var style: MagellanStyleProtocol { get }
    var phoneFormatter: PhoneFormatterProtocol? { get set }
    
    var distanceFilter: Double { get set }
    var defaultCoordinate: Coordinates { get set }
    
    var networkOperationFactory: MiddlewareOperationFactoryProtocol { get }
    var markerFactory: MapMarkerFactoryProtocol? { get set }
    
    var localizationResourcesFactory: LocalizedResourcesFactoryProtocol { get }
    var parameters: MagellanParametersProtocol { get }
    
    var logger: LoggerDecorator? { get }
    var alertHelper: AlertHelperProtocol? { get }
}

extension ResolverProtocol {
    var networkService: MagellanServicePrototcol {
        return MagellanService(operationFactory: networkOperationFactory)
    }
}

final class Resolver: ResolverProtocol {
    
    var style: MagellanStyleProtocol
    var phoneFormatter: PhoneFormatterProtocol?
    
    var distanceFilter: Double = 50
    var defaultCoordinate: Coordinates = Coordinates(lat: 11.5796669, lon: 104.7501013)
    
    let networkOperationFactory: MiddlewareOperationFactoryProtocol
    let localizationResourcesFactory: LocalizedResourcesFactoryProtocol
    var markerFactory: MapMarkerFactoryProtocol?
    var parameters: MagellanParametersProtocol
    private(set) var logger: LoggerDecorator?
    private(set) var alertHelper: AlertHelperProtocol?
    
    init(networkOperationFactory: MiddlewareOperationFactoryProtocol,
         style: MagellanStyleProtocol,
         localizationResourcesFactory: LocalizedResourcesFactoryProtocol,
         parameters: MagellanParametersProtocol,
         logger: LoggerProtocol?,
         alertHelper: AlertHelperProtocol?) {
        self.networkOperationFactory = networkOperationFactory
        self.style = style
        self.localizationResourcesFactory = localizationResourcesFactory
        self.parameters = parameters
        if let logger = logger {
            self.logger = LoggerDecorator(logger: logger)
        }
        self.alertHelper = alertHelper
    }
    
}
