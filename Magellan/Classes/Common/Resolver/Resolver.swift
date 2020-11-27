/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

public typealias Closure = () -> Void

protocol ResolverProtocol {
    
    var style: MagellanStyleProtocol { get }
    var phoneFormatter: PhoneFormatterProtocol? { get set }
    
    var distanceFilter: Double { get set }
    var defaultCoordinate: Coordinates { get set }
    
    var markerFactory: MapMarkerFactoryProtocol? { get set }
    
    var localizationResourcesFactory: LocalizedResourcesFactoryProtocol { get }
    var parameters: MagellanParametersProtocol { get }
    
    var logger: LoggerDecorator? { get }
    var alertHelper: AlertHelperProtocol? { get }

    var moduleAppersClosure: Closure? { get set }
    var moduleDisappersClosure: Closure? { get set }
    
    var networkService: MagellanServicePrototcol { get }

}

final class Resolver: ResolverProtocol {
    
    var style: MagellanStyleProtocol
    var phoneFormatter: PhoneFormatterProtocol?
    
    var distanceFilter: Double = 50
    var defaultCoordinate: Coordinates = Coordinates(lat: 11.5796669, lon: 104.7501013)
    
    let localizationResourcesFactory: LocalizedResourcesFactoryProtocol
    var markerFactory: MapMarkerFactoryProtocol?
    var parameters: MagellanParametersProtocol
    private(set) var logger: LoggerDecorator?
    private(set) var alertHelper: AlertHelperProtocol?

    var moduleAppersClosure: Closure?
    var moduleDisappersClosure: Closure?
    
    var networkService: MagellanServicePrototcol
    
    init(networkService: MagellanServicePrototcol,
         style: MagellanStyleProtocol,
         localizationResourcesFactory: LocalizedResourcesFactoryProtocol,
         parameters: MagellanParametersProtocol,
         logger: LoggerProtocol?,
         alertHelper: AlertHelperProtocol?) {
        self.style = style
        self.localizationResourcesFactory = localizationResourcesFactory
        self.parameters = parameters
        if let logger = logger {
            self.logger = LoggerDecorator(logger: logger)
        }
        self.alertHelper = alertHelper
        self.networkService = networkService
    }
    
}
