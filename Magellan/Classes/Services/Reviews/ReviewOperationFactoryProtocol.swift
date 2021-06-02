//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood

protocol ReviewOperationFactoryProtocol {}

extension ReviewOperationFactoryProtocol where Self: MiddlewareOperationFactoryProtocol {
        
    func fetchLastReviews(with placeId: String, request: MagellanRequestType = .placeLastReviews) -> BaseOperation<PlaceReview> {
        let urlTemplate = networkResolver.urlTemplate(for: request)
        
        let requestFactory = BlockNetworkRequestFactory {
            let url = try EndpointBuilder(urlTemplate: urlTemplate).buildParameterURL(placeId)
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<PlaceReview> { data in
            let resultData = try self.decoder.decode(ResultData<PlaceReview>.self, from: data)
            
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
    
    func fetchAllReviews(with placeId: String, request: MagellanRequestType = .placeAllReviews) -> BaseOperation<[Review]> {
        let urlTemplate = networkResolver.urlTemplate(for: request)
        
        let requestFactory = BlockNetworkRequestFactory {
            let url = try EndpointBuilder(urlTemplate: urlTemplate).buildParameterURL(placeId)
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<[Review]> { data in
            let resultData = try self.decoder.decode(ResultData<[Review]>.self, from: data)
            
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
    
    func fetchPlaceSummary(with placeID: String) -> BaseOperation<(PlaceInfo, PlaceReview)> {
        
        let infoOperation = fetchPlaceInfo(with: placeID)
        let reviewsOperation = fetchLastReviews(with: placeID)
        
        let resultOperation: BaseOperation<(PlaceInfo, PlaceReview)> = ClosureOperation {
            guard let infoResult = infoOperation.result,
                  let reviewsResult = reviewsOperation.result else {
                    throw MagellanServiceError.noResult
            }
            switch (infoResult, reviewsResult) {
            case (.success(let info), .success(let reviews)):
                return (info, reviews)
            case (.failure(let error), _):
                throw error
            case (_, .failure(let error)):
                throw error
            }
        }
        
        resultOperation.addDependency(infoOperation)
        resultOperation.addDependency(reviewsOperation)
        
        return resultOperation
    }
}
