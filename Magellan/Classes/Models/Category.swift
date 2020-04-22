//
	/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Category {
    let id: Int
    let name: String
}

extension Category: Equatable { }
extension Category: Codable { }
