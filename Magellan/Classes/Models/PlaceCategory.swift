//
	/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public struct PlaceCategory: Equatable, Codable, Hashable, Comparable {
    
    let id: UInt64
    let name: String
    let khmerName: String?
    
    public static func == (lhs: PlaceCategory, rhs: PlaceCategory) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.id < rhs.id
    }
    
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.id <= rhs.id
    }
    
}
