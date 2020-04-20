/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

protocol ResolverProtocol {
    var networkOperationFactory: MiddlewareOperationFactoryProtocol { get }
}

final class Resolver: ResolverProtocol {
    
    let networkOperationFactory: MiddlewareOperationFactoryProtocol
    
    init(networkOperationFactory: MiddlewareOperationFactoryProtocol) {
        self.networkOperationFactory = networkOperationFactory
    }
    
}
