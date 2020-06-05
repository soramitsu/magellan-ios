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
    func with(errorViewFactory: ErrorViewFactoryProtocol) -> Self
    
    @discardableResult
    func with(localizedResourcesFactory: LocalizedResorcesFactoryProtocol) -> Self
}

public final class MaggelanBuilder {
    
    private let apiKey: String
    private var style: MagellanStyleProtocol?
    private var phoneFormatter: PhoneFormatterProtocol?
    private var errorViewFactory: ErrorViewFactoryProtocol?
    private var localizedResourcesFactory: LocalizedResorcesFactoryProtocol?
    
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
                                localizationResourcesFactory: localizedResourcesFactory ?? DefaultLocalizedResorcesFactory())
        resolver.phoneFormatter = phoneFormatter
        resolver.errorViewFactory = errorViewFactory
        
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
    
    public func with(errorViewFactory: ErrorViewFactoryProtocol) -> Self{
        self.errorViewFactory = errorViewFactory
        return self
    }
    
    
    public func with(localizedResourcesFactory: LocalizedResorcesFactoryProtocol) -> Self {
        self.localizedResourcesFactory = localizedResourcesFactory
        return self
    }
}
