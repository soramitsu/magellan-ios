//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood

enum MagellanServiceError: Error {
    case noResult
}

final class MagellanService {
    let operationQueue: OperationQueue
    let operationFactory: MiddlewareOperationFactoryProtocol
    
    init(operationFactory: MiddlewareOperationFactoryProtocol,
         operationQueue: OperationQueue = OperationQueue()) {
        self.operationFactory = operationFactory
        self.operationQueue = operationQueue
    }
}

extension MagellanService: MagellanServiceProtocol {
    
    func getCategories(runCompletionIn queue: DispatchQueue, completion: @escaping CategoriesCompletionBlock) -> Operation {
        let operation = operationFactory.fetchCategories()
        
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
    
    func getPlace(with placeId: String, runCompletionIn queue: DispatchQueue, completion: @escaping PlaceInfoCompletionBlock) -> Operation {
        let operation = operationFactory.fetchPlaceInfo(with: placeId)
        
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
    
    func getPlaces(with request: PlacesRequest, runCompletionIn queue: DispatchQueue, completion: @escaping PlacesCompletionBlock) -> Operation {
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
