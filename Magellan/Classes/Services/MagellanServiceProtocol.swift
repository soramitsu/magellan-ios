//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import RobinHood

typealias CategoriesCompletionBlock = (Result<[PlaceCategory], Error>) -> Void
typealias PlaceInfoCompletionBlock = (Result<PlaceInfo, Error>) -> Void
typealias PlacesCompletionBlock = (Result<PlacesResponse, Error>) -> Void
typealias CategoriesAndPlacesBlock = (Result<([PlaceCategory], PlacesResponse), Error>) -> Void


protocol MagellanServicePrototcol: AutoMockable {
    
    @discardableResult
    func getCategories(runCompletionIn queue: DispatchQueue, completion: @escaping CategoriesCompletionBlock) -> Operation
    
    @discardableResult
    func getPlace(with placeId: Int, runCompletionIn queue: DispatchQueue, completion: @escaping PlaceInfoCompletionBlock) -> Operation
    
    @discardableResult
    func getPlaces(with request: PlacesRequest, runCompletionIn queue: DispatchQueue, completion: @escaping PlacesCompletionBlock) -> Operation
    
    @discardableResult
    func getCategoriesAndPlaces(with request: PlacesRequest, runCompletionIn queue: DispatchQueue, completion: @escaping CategoriesAndPlacesBlock) -> Operation
}
