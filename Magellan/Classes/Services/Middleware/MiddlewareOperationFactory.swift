//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MiddlewareOperationFactory: MiddlewareOperationFactoryProtocol {
    let networkResolver: MagellanNetworkResolverProtocol
    private(set) lazy var decoder = JSONDecoder()
    private(set) lazy var encoder = JSONEncoder()
    
    init(networkResolver: MagellanNetworkResolverProtocol) {
        self.networkResolver = networkResolver
    }
}

final class ReviewOperationFactory: ReviewOperationFactoryProtocol {

    let decorated: MiddlewareOperationFactoryProtocol
    var networkResolver: MagellanNetworkResolverProtocol { decorated.networkResolver }
    var encoder: JSONEncoder { decorated.encoder }
    var decoder: JSONDecoder { decorated.decoder }
    
    internal init(decorated: MiddlewareOperationFactoryProtocol) {
        self.decorated = decorated
    }
}

protocol ReviewOperationFactoryProtocol: MiddlewareOperationFactoryProtocol {}

