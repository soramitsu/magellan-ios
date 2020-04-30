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
    func with(alertManager: AlertManagerProtocol) -> Self
    
    @discardableResult
    func with(defaultAlertMessage: MessageProtocol) -> Self
    
    @discardableResult
    func with(phoneFormatter: PhoneFormatterProtocol) -> Self
}

public final class MaggelanBuilder {
    
    private let apiKey: String
    private var style: MagellanStyleProtocol?
    private var alertManager: AlertManagerProtocol?
    private var defaultAlertMessage: MessageProtocol?
    private var phoneFormatter: PhoneFormatterProtocol?
    
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
                                style: self.style ?? DefaultMagellanStyle())
        resolver.alertManager = alertManager
        resolver.phoneFormatter = phoneFormatter
        
        return DashboardMapAssembly.assembly(with: resolver)
    }
    
    public func with(style: MagellanStyleProtocol) -> Self {
        self.style = style
        return self
    }
    
    public func with(alertManager: AlertManagerProtocol) -> Self {
        self.alertManager = alertManager
        return self
    }
    
    public func with(defaultAlertMessage: MessageProtocol) -> Self {
        self.defaultAlertMessage = defaultAlertMessage
        return self
    }
    
    public func with(phoneFormatter: PhoneFormatterProtocol) -> Self {
        self.phoneFormatter = phoneFormatter
        return self
    }
}
