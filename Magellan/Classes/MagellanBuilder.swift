/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import GoogleMaps

public protocol MaggelanBuilderProtocol {
    func build(networkResolver: MagellanNetworkResolverProtocol) throws -> UIViewController
}

public final class MaggelanBuilder {
    
    private let apiKey: String
    
    /// Initializator
    /// - Parameter key: google mpas api key
    public init(key: String) {
        apiKey = key
        UIFont.registerFonts()
    }
}

extension MaggelanBuilder: MaggelanBuilderProtocol {
    public func build(networkResolver: MagellanNetworkResolverProtocol) -> UIViewController {
        GMSServices.provideAPIKey(apiKey)
        
        let networkOperationFactory = MiddlewareOperationFactory(networkResolver: networkResolver)
        
        let resolver = Resolver(networkOperationFactory: networkOperationFactory)
        
        return DashboardMapAssembly.assembly(with: resolver)
    }
}
