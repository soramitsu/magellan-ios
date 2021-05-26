//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol MagellanReviewServiceProtocol {
    
    @discardableResult
    func getAllReviews(with placeId: String) -> Operation
    
    @discardableResult
    func getLastReviews(with placeId: String) -> Operation
    
}
