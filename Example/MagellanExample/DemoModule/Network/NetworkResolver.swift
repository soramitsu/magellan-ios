//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Magellan
import RobinHood
import OHHTTPStubs

struct MaggelanAuthNetworkAdapter: NetworkRequestModifierProtocol {
    let apiToken: String
    
    init(token: String) {
        apiToken = token
    }
    
    func modify(request: URLRequest) throws -> URLRequest {
        var adapted = request
        let bearer = "Bearer \(String(describing: apiToken))"
        
        adapted.setValue(bearer, forHTTPHeaderField: "Authorization")
        adapted.setValue("IOS", forHTTPHeaderField: "Client-Name")
        return adapted
    }
}

class NetworkResolver: MagellanNetworkResolverProtocol {
    
    let baseUrl: URL
    
    private var authAdapger: NetworkRequestModifierProtocol?
    var token: String? {
        didSet {
            guard let token = token else {
                authAdapger = nil
                return
            }
            authAdapger = MaggelanAuthNetworkAdapter(token: token)
        }
    }
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func urlTemplate(for type: MagellanRequestType) -> String {
        baseUrl.appendingPathComponent(makePathComponent(for: type)).absoluteString
    }
    
    func adapter(for type: MagellanRequestType) -> NetworkRequestModifierProtocol? {
        // todo: add auth token header
        return authAdapger
    }
    
    func errorFactory(for type: MagellanRequestType) -> MagellanErrorNetworkFactoryProtocol? {
        return nil
    }
}

extension NetworkResolver {
    
    func makePathComponent(for type: MagellanRequestType) -> String {
        switch type {
        case .categories:
            return "/paymentservice/api/v1/merchants/types"
        case .placeInfo:
            return "/paymentservice/api/v1/merchants/{placeId}"
        case .placesList:
            return "/paymentservice/api/v1/merchants"
        case .placeAllReviews:
            return "/paymentservice/api/v1/merchants/reviews/{id}"
        case .placeLastReviews:
            return "/paymentservice/api/v1/merchants/reviews/partial/{id}"
        }
    }
    
}
