/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct PlaceInfo {
    let id: Int
    let name: String
    let type: String
    let coordinates: Coordinates
    let address: String
    let phoneNumber: String
    let openHours: String
    let website: String
    let facebook: String
    let logoUuid: String
    let promoImageUuid: String
    let distance: String
}

extension PlaceInfo: Codable { }
extension PlaceInfo: Equatable { }
