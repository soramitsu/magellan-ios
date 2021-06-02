//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Review: Codable {
    let score: Double
    let text: String
    let createdByName: String
    let createTime: String
    let isUserReview: Bool?
}

struct PlaceReview: Codable {
    let latestReviews: [Review]
    let userReview: Review?
}
