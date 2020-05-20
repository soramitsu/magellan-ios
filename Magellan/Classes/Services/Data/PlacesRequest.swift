//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public struct PlacesRequest: Codable {
    
    let topLeft: Coordinates
    let bottomRight: Coordinates
    let search: String?
    let categories: [String]
    
}
