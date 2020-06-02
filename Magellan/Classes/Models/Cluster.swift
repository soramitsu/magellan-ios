//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Cluster: Coordinated {
    let type: String // can be enum, ask backend developer
    let count: Int
    let centroid: Coordinates
    
    var coordinates: Coordinates {
        return centroid
    }
}

extension Cluster: Codable { }
extension Cluster: Equatable { }
