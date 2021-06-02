//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood

protocol ReviewOperationFactoryProtocol {}

extension ReviewOperationFactoryProtocol where Self: MiddlewareOperationFactoryProtocol {
        
    func fetchLastReviews(with placeId: String, request: MagellanRequestType = .placeLastReviews) -> BaseOperation<[PlaceReview]> {
        let urlTemplate = networkResolver.urlTemplate(for: request)
        
        let requestFactory = BlockNetworkRequestFactory {
            let url = try EndpointBuilder(urlTemplate: urlTemplate).buildParameterURL(placeId)
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<[PlaceReview]> { data in
            let resultData = try self.decoder.decode(ResultData<[PlaceReview]>.self, from: data)
            
            if let error = self.error(for: resultData.status, requestType: request) {
                throw error
            }
            
            guard let result = resultData.result else {
                throw NetworkBaseError.unexpectedResponseObject
            }
            
            return result
        }
        
        let operation = NetworkOperation(requestFactory: requestFactory, resultFactory: resultFactory)
        operation.requestModifier = networkResolver.adapter(for: request)
        
        return operation
    }
    
    func fetchAllReviews(with placeId: String, request: MagellanRequestType = .placeAllReviews) -> BaseOperation<[PlaceReview]> {
        let urlTemplate = networkResolver.urlTemplate(for: request)
        
        let requestFactory = BlockNetworkRequestFactory {
            let url = try EndpointBuilder(urlTemplate: urlTemplate).buildParameterURL(placeId)
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<[PlaceReview]> { data in
            let resultData = try self.decoder.decode(ResultData<[PlaceReview]>.self, from: data)
            
            if let error = self.error(for: resultData.status, requestType: request) {
                throw error
            }
            
            guard let result = resultData.result else {
                throw NetworkBaseError.unexpectedResponseObject
            }
            
            return result
        }
        
        let operation = NetworkOperation(requestFactory: requestFactory, resultFactory: resultFactory)
        operation.requestModifier = networkResolver.adapter(for: request)
        
        return operation
    }
}
