//
	/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct PlaceCategory {
    let id: UInt64
    let name: String
    let khmerName: String?
}

extension PlaceCategory: Equatable {
    static func == (lhs: PlaceCategory, rhs: PlaceCategory) -> Bool {
        return lhs.id == rhs.id
    }
}
extension PlaceCategory: Codable { }

extension PlaceCategory: Hashable { }
extension PlaceCategory: Comparable {
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.id <= rhs.id
    }
    
}
