//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood

typealias CategoriesCompletionBlock = (Result<[Category], Error>) -> Void
typealias PlaceInfoCompletionBlock = (Result<PlaceInfo, Error>) -> Void
typealias PlacesCompletionBlock = (Result<PlacesResponse, Error>) -> Void


protocol MagellanServicePrototcol {
    
    @discardableResult
    func getCategories(runCompletionIn queue: DispatchQueue, completion: @escaping CategoriesCompletionBlock) -> Operation
    
    @discardableResult
    func getPlace(with placeId: Int, runCompletionIn queue: DispatchQueue, completion: @escaping PlaceInfoCompletionBlock) -> Operation
    
    @discardableResult
    func getPlaces(with request: PlacesRequest, runCompletionIn queue: DispatchQueue, completion: @escaping PlacesCompletionBlock) -> Operation
}
