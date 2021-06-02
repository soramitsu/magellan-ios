//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood

protocol MiddlewareOperationFactoryProtocol: ReviewOperationFactoryProtocol {
    var networkResolver: MagellanNetworkResolverProtocol { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
}

extension MiddlewareOperationFactoryProtocol {
    func fetchCategories() -> BaseOperation<[PlaceCategory]> {
        let path = networkResolver.urlTemplate(for: .categories)
        
        let requestFactory = BlockNetworkRequestFactory {
            guard let url = URL(string: path) else {
                throw NetworkBaseError.invalidUrl
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<[PlaceCategory]> { data in
            let result = try self.decoder.decode(ResultData<[PlaceCategory]>.self, from: data)
            
            if let error = self.error(for: result.status, requestType: .categories) {
                throw error
            }
            
            guard let categories = result.result else {
                throw NetworkBaseError.unexpectedResponseObject
            }
            
            return categories
        }
        
        let operation = NetworkOperation(requestFactory: requestFactory, resultFactory: resultFactory)
        operation.requestModifier = networkResolver.adapter(for: .categories)
        
        return operation
    }
    
    func fetchPlaceInfo(with placeId: String) -> BaseOperation<PlaceInfo> {
        let urlTemplate = networkResolver.urlTemplate(for: .placeInfo)
        
        let requestFactory = BlockNetworkRequestFactory {
            let url = try EndpointBuilder(urlTemplate: urlTemplate).buildParameterURL(placeId)
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<PlaceInfo> { data in
            let result = try self.decoder.decode(ResultData<PlaceInfo>.self, from: data)
            
            if let error = self.error(for: result.status, requestType: .placeInfo) {
                throw error
            }
            
            guard let placeInfo = result.result else {
                throw NetworkBaseError.unexpectedResponseObject
            }
            
            return placeInfo
        }
        
        let operation = NetworkOperation(requestFactory: requestFactory, resultFactory: resultFactory)
        operation.requestModifier = networkResolver.adapter(for: .categories)
        
        return operation
    }
    
    func fetchPlaces(with requestBody: PlacesRequest) -> BaseOperation<PlacesResponse> {
        let path = networkResolver.urlTemplate(for: .placesList)
        
        let requestFactory = BlockNetworkRequestFactory {
            guard let url = URL(string: path) else {
                throw NetworkBaseError.invalidUrl
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.post.rawValue
            request.addValue(HttpContentType.json.rawValue, forHTTPHeaderField: HttpHeaderKey.contentType.rawValue)
            request.httpBody = try self.encoder.encode(requestBody)
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<PlacesResponse> { data in
            let result = try self.decoder.decode(ResultData<PlacesResponse>.self, from: data)
            
            if let error = self.error(for: result.status, requestType: .placesList) {
                throw error
            }
            
            guard let places = result.result else {
                throw NetworkBaseError.unexpectedResponseObject
            }
            
            return places
        }
        
        let operation = NetworkOperation(requestFactory: requestFactory, resultFactory: resultFactory)
        operation.requestModifier = networkResolver.adapter(for: .categories)
        
        return operation
    }
    
    func fetchCategoriesAndPlaces(with request: PlacesRequest) -> BaseOperation<([PlaceCategory], PlacesResponse)> {
        let categoriesOperation = fetchCategories()
        let placesOperation = fetchPlaces(with: request)
        
        let sumOperation: BaseOperation<([PlaceCategory], PlacesResponse)> = ClosureOperation {
            guard let categoriesResult = categoriesOperation.result,
                let placesResult = placesOperation.result else {
                    throw MagellanServiceError.noResult
            }
            switch (categoriesResult, placesResult) {
            case (.success(let categories), .success(let places)):
                return (categories, places)
            case (.failure(let categoriesError), _):
                throw categoriesError
            case (_, .failure(let placesError)):
                throw placesError
            }
        }
        
        sumOperation.addDependency(categoriesOperation)
        sumOperation.addDependency(placesOperation)
        
        return sumOperation
    }
    
    func error(for status: StatusData,  requestType: MagellanRequestType) -> Error? {
        if status.isSuccess {
            return nil
        }
        
        if let errorFactory = self.networkResolver.errorFactory(for: .placeInfo) {
            return errorFactory.createErrorFromStatus(status.code)
        } else {
            return ResultStatueError(with: status)
        }
    }
}

struct PlaceReview: Codable {}

protocol ReviewOperationFactoryProtocol {}

extension ReviewOperationFactoryProtocol where Self: MiddlewareOperationFactoryProtocol {
        
    func fetchLastReviews(with placeId: String) -> BaseOperation<[PlaceReview]> {
        let urlTemplate = networkResolver.urlTemplate(for: .placeInfo)
        
        let requestFactory = BlockNetworkRequestFactory {
            let url = try EndpointBuilder(urlTemplate: urlTemplate).buildParameterURL(placeId)
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<[PlaceReview]> { data in
            let result = try self.decoder.decode(ResultData<[PlaceReview]>.self, from: data)
            
            if let error = self.error(for: result.status, requestType: .placeLastReviews) {
                throw error
            }
            
            guard let result = result.result else {
                throw NetworkBaseError.unexpectedResponseObject
            }
            
            return result
        }
        
        let operation = NetworkOperation(requestFactory: requestFactory, resultFactory: resultFactory)
        operation.requestModifier = networkResolver.adapter(for: .placeLastReviews)
        
        return operation
    }
    
    func fetchAllReviews(with placeId: String) -> BaseOperation<[PlaceReview]> {
        let urlTemplate = networkResolver.urlTemplate(for: .placeAllReviews)
        
        let requestFactory = BlockNetworkRequestFactory {
            let url = try EndpointBuilder(urlTemplate: urlTemplate).buildParameterURL(placeId)
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<[PlaceReview]> { data in
            let result = try self.decoder.decode(ResultData<[PlaceReview]>.self, from: data)
            
            if let error = self.error(for: result.status, requestType: .placeAllReviews) {
                throw error
            }
            
            guard let placeInfo = result.result else {
                throw NetworkBaseError.unexpectedResponseObject
            }
            
            return placeInfo
        }
        
        let operation = NetworkOperation(requestFactory: requestFactory, resultFactory: resultFactory)
        operation.requestModifier = networkResolver.adapter(for: .placeAllReviews)
        
        return operation
    }
}
