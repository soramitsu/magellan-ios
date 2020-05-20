//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Cluster: Coordinated {
    let type: String // can be enum, ask backend developer
    let quantity: Int
    let lat: Double
    let lon: Double
    
    var coordinates: Coordinates {
        return Coordinates(lat: lat, lon: lon)
    }
}

extension Cluster: Codable { }
extension Cluster: Equatable { }
