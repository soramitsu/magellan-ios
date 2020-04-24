//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public struct PlacesRequest: Codable {
    
    let location: String
    let search: String?
    let category: String?
    
}
