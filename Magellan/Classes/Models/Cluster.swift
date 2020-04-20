//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Cluster {
    let type: String // can be enum, ask backend developer
    let quantity: Int
}

extension Cluster: Codable { }
extension Cluster: Equatable { }
