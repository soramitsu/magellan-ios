//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol MagellanReviewServiceProtocol {
    
    @discardableResult
    func getPlaceSummaryInfo(with placeId: String,
                             runCompletionIn queue: DispatchQueue,
                             completion: @escaping (Result<(PlaceInfo), Error>) -> Void) -> Operation
    
    @discardableResult
    func getLastReviews(with placeId: String,
                        runCompletionIn queue: DispatchQueue,
                        completion: @escaping (Result<PlaceReview, Error>) -> Void) -> Operation

    @discardableResult
    func getAllReviews(with placeId: String,
                       runCompletionIn queue: DispatchQueue,
                       completion: @escaping (Result<[Review], Error>) -> Void) -> Operation
}

extension MagellanService: MagellanReviewServiceProtocol {
    
    @discardableResult
    func getPlaceSummaryInfo(with placeId: String,
                             runCompletionIn queue: DispatchQueue,
                             completion: @escaping (Result<(PlaceInfo), Error>) -> Void) -> Operation {
    
        let operation = operationFactory.fetchPlaceSummary(with: placeId)
        
        operation.completionBlock = {
            queue.async {
                switch operation.result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(var result):
                    result.0.append(result.1)
                    completion(.success(result.0))
                case .none:
                    return
                }
            }
        }
        
        operationQueue.addOperation(operation)
        operation.dependencies.forEach { operationQueue.addOperation($0) }
        
        return operation
    }
    
    @discardableResult
    func getLastReviews(with placeId: String,
                        runCompletionIn queue: DispatchQueue,
                        completion: @escaping (Result<PlaceReview, Error>) -> Void) -> Operation {
       
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
                       completion: @escaping (Result<[Review], Error>) -> Void) -> Operation {
        
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
