//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public struct Position: Codable {
    
    let upperLeft: String
    let lowerRight: String
    
}

public struct PlacesRequest: Codable {
    
    let position: Position
    let zoom: Int
    let search: String?
    let category: String?
    
}
