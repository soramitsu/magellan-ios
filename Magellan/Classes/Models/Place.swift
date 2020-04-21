//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Place {
    let id: Int
    let name: String
    let type: String
    let lat: Double
    let lon: Double
}

extension Place {
    var coordinates: Coordinates {
       return Coordinates(lat: lat, lon: lon)
    }
}

extension Place: Codable { }
extension Place: Equatable { }
