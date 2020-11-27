//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood

public typealias CategoriesCompletionBlock = (Result<[PlaceCategory], Error>) -> Void
public typealias PlaceInfoCompletionBlock = (Result<PlaceInfo, Error>) -> Void
public typealias PlacesCompletionBlock = (Result<PlacesResponse, Error>) -> Void


public protocol MagellanServicePrototcol {
    
    @discardableResult
    func getCategories(runCompletionIn queue: DispatchQueue, completion: @escaping CategoriesCompletionBlock) -> Operation
    
    @discardableResult
    func getPlace(with placeId: String, runCompletionIn queue: DispatchQueue, completion: @escaping PlaceInfoCompletionBlock) -> Operation
    
    @discardableResult
    func getPlaces(with request: PlacesRequest, runCompletionIn queue: DispatchQueue, completion: @escaping PlacesCompletionBlock) -> Operation
}
