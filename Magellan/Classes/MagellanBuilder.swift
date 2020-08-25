/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import GoogleMaps

public protocol MaggelanBuilderProtocol {
    func build(networkResolver: MagellanNetworkResolverProtocol) throws -> UIViewController
    
    @discardableResult
    func with(style: MagellanStyleProtocol) -> Self
    
    @discardableResult
    func with(phoneFormatter: PhoneFormatterProtocol) -> Self
    
    @discardableResult
    func with(localizedResourcesFactory: LocalizedResourcesFactoryProtocol) -> Self
    
    @discardableResult
    func with(parameters: MagellanParametersProtocol) -> Self
    
    @discardableResult
    func with(logger: LoggerProtocol) -> Self

    @discardableResult
    func with(alertHelper: AlertHelperProtocol) -> Self
}

public final class MaggelanBuilder {
    
    private let apiKey: String
    private var style: MagellanStyleProtocol?
    private var phoneFormatter: PhoneFormatterProtocol?
    private var localizedResourcesFactory: LocalizedResourcesFactoryProtocol?
    private var parameters: MagellanParametersProtocol?
    private var logger: LoggerProtocol?
    private var alertHelper: AlertHelperProtocol?
    
    /// Initializator
    /// - Parameter key: google mpas api key
    public init(key: String) {
        apiKey = key
    }
}

extension MaggelanBuilder: MaggelanBuilderProtocol {
    public func build(networkResolver: MagellanNetworkResolverProtocol) -> UIViewController {
        GMSServices.provideAPIKey(apiKey)
        
        let networkOperationFactory = MiddlewareOperationFactory(networkResolver: networkResolver)
        
        let resolver = Resolver(networkOperationFactory: networkOperationFactory,
                                style: self.style ?? DefaultMagellanStyle(),
                                localizationResourcesFactory: localizedResourcesFactory ?? DefaultLocalizedResorcesFactory(),
                                parameters: parameters ?? DefaultMagellanParameters(),
                                logger: logger,
                                alertHelper: alertHelper)
        resolver.phoneFormatter = phoneFormatter
        
        return DashboardMapAssembly.assembly(with: resolver)
    }
    
    public func with(style: MagellanStyleProtocol) -> Self {
        self.style = style
        return self
    }
    
    public func with(phoneFormatter: PhoneFormatterProtocol) -> Self {
        self.phoneFormatter = phoneFormatter
        return self
    }
    
    public func with(localizedResourcesFactory: LocalizedResourcesFactoryProtocol) -> Self {
        self.localizedResourcesFactory = localizedResourcesFactory
        return self
    }
    
    public func with(parameters: MagellanParametersProtocol) -> Self {
        self.parameters = parameters
        return self
    }
    
    public func with(logger: LoggerProtocol) -> Self {
        self.logger = logger
        return self
    }

    public func with(alertHelper: AlertHelperProtocol) -> Self {
        self.alertHelper = alertHelper
        return self
    }
}
