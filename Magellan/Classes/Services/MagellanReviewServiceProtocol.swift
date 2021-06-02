//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public struct AllReviewsRequest: Codable {}
public struct LastReviewsRequest: Codable {}

protocol MagellanReviewServiceProtocol {
    
    @discardableResult
    func get(request: AllReviewsRequest, queue: DispatchQueue) -> Operation
    
    @discardableResult
    func get(request: LastReviewsRequest, queue: DispatchQueue) -> Operation
    
}

extension MagellanService: MagellanReviewServiceProtocol {
    
    @discardableResult
    func get(request: AllReviewsRequest, queue: DispatchQueue) -> Operation {
        let operation = operationFactory.fetchPlaces(with: request)
        
        operation.completionBlock = {
            queue.async {
                switch operation.result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let result):
                    completion(.success(result))
                case .none:
                    return
                }
            }
        }
        
        operationQueue.addOperation(operation)
        
        return operation
    }
    
    @discardableResult
    func get(request: LastReviewsRequest, queue: DispatchQueue) -> Operation {
        let operation = operationFactory.fetchPlaces(with: request)
        
        operation.completionBlock = {
            queue.async {
                switch operation.result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let result):
                    completion(.success(result))
                case .none:
                    return
                }
            }
        }
        
        operationQueue.addOperation(operation)
        
        return operation
    }
    
}
