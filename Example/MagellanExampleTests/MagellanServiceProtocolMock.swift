//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
@testable import Magellan

class MagellanServicePrototcolMock: MagellanServicePrototcol {

    //MARK: - getCategories

    var getCategoriesRunCompletionInCompletionCallsCount = 0
    var getCategoriesRunCompletionInCompletionCalled: Bool {
        return getCategoriesRunCompletionInCompletionCallsCount > 0
    }
    var getCategoriesRunCompletionInCompletionReceivedArguments: (queue: DispatchQueue, completion: CategoriesCompletionBlock)?
    var getCategoriesRunCompletionInCompletionReturnValue: Operation!
    var getCategoriesRunCompletionInCompletionClosure: ((DispatchQueue, @escaping CategoriesCompletionBlock) -> Operation)?

    func getCategories(runCompletionIn queue: DispatchQueue, completion: @escaping CategoriesCompletionBlock) -> Operation {
        getCategoriesRunCompletionInCompletionCallsCount += 1
        getCategoriesRunCompletionInCompletionReceivedArguments = (queue: queue, completion: completion)
        return getCategoriesRunCompletionInCompletionClosure.map({ $0(queue, completion) }) ?? getCategoriesRunCompletionInCompletionReturnValue
    }

    //MARK: - getPlace

    var getPlaceWithRunCompletionInCompletionCallsCount = 0
    var getPlaceWithRunCompletionInCompletionCalled: Bool {
        return getPlaceWithRunCompletionInCompletionCallsCount > 0
    }
    var getPlaceWithRunCompletionInCompletionReceivedArguments: (placeId: String, queue: DispatchQueue, completion: PlaceInfoCompletionBlock)?
    var getPlaceWithRunCompletionInCompletionReturnValue: Operation!
    var getPlaceWithRunCompletionInCompletionClosure: ((String, DispatchQueue, @escaping PlaceInfoCompletionBlock) -> Operation)?

    func getPlace(with placeId: String, runCompletionIn queue: DispatchQueue, completion: @escaping PlaceInfoCompletionBlock) -> Operation {
        getPlaceWithRunCompletionInCompletionCallsCount += 1
        getPlaceWithRunCompletionInCompletionReceivedArguments = (placeId: placeId, queue: queue, completion: completion)
        return getPlaceWithRunCompletionInCompletionClosure.map({ $0(placeId, queue, completion) }) ?? getPlaceWithRunCompletionInCompletionReturnValue
    }

    //MARK: - getPlaces

    var getPlacesWithRunCompletionInCompletionCallsCount = 0
    var getPlacesWithRunCompletionInCompletionCalled: Bool {
        return getPlacesWithRunCompletionInCompletionCallsCount > 0
    }
    var getPlacesWithRunCompletionInCompletionReceivedArguments: (request: PlacesRequest, queue: DispatchQueue, completion: PlacesCompletionBlock)?
    var getPlacesWithRunCompletionInCompletionReturnValue: Operation!
    var getPlacesWithRunCompletionInCompletionClosure: ((PlacesRequest, DispatchQueue, @escaping PlacesCompletionBlock) -> Operation)?

    func getPlaces(with request: PlacesRequest, runCompletionIn queue: DispatchQueue, completion: @escaping PlacesCompletionBlock) -> Operation {
        getPlacesWithRunCompletionInCompletionCallsCount += 1
        getPlacesWithRunCompletionInCompletionReceivedArguments = (request: request, queue: queue, completion: completion)
        return getPlacesWithRunCompletionInCompletionClosure.map({ $0(request, queue, completion) }) ?? getPlacesWithRunCompletionInCompletionReturnValue
    }

}

