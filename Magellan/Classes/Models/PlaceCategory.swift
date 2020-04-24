//
	/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct PlaceCategory {
    let id: Int
    let name: String
}

extension PlaceCategory: Equatable { }
extension PlaceCategory: Codable { }
