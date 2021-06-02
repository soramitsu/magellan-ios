//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol MagellanReviewServiceProtocol {
    
    @discardableResult
    func getLastReviews(with placeId: String,
                        runCompletionIn queue: DispatchQueue,
                        completion: @escaping (Result<[PlaceReview], Error>) -> Void) -> Operation

    @discardableResult
    func getAllReviews(with placeId: String,
                       runCompletionIn queue: DispatchQueue,
                       completion: @escaping (Result<[PlaceReview], Error>) -> Void) -> Operation
}

extension MagellanService: MagellanReviewServiceProtocol {
    
    @discardableResult
    func getLastReviews(with placeId: String,
                        runCompletionIn queue: DispatchQueue,
                        completion: @escaping (Result<[PlaceReview], Error>) -> Void) -> Operation {
       
        let operation = operationFactory.fetchLastReviews(with: placeId)
        
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
    func getAllReviews(with placeId: String,
                       runCompletionIn queue: DispatchQueue,
                       completion: @escaping (Result<[PlaceReview], Error>) -> Void) -> Operation {
        
        let operation = operationFactory.fetchAllReviews(with: placeId)
        
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
