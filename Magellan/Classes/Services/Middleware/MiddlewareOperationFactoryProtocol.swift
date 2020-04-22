//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood

protocol MiddlewareOperationFactoryProtocol {
    var networkResolver: MagellanNetworkResolverProtocol { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
}

extension MiddlewareOperationFactoryProtocol {
    func fetchCategories() -> BaseOperation<[Category]> {
        let path = networkResolver.urlTemplate(for: .categories)
        
        let requestFactory = BlockNetworkRequestFactory {
            guard let url = URL(string: path) else {
                throw NetworkBaseError.invalidUrl
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            
            return request
        }
        
        let resultFactory = AnyNetworkResultFactory<[Category]> { data in
            let result = try self.decoder.decode(ResultData<[Category]>.self, from: data)
            
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
    
    private func error(for status: StatusData,  requestType: MagellanRequestType) -> Error? {
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
