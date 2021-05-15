//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct Place {
    let id: String
    let name: String
    let type: String
    let types: Types?
    let khmerType: String?
    let coordinates: Coordinates
}

struct Types: Codable, Equatable {
    let eng: String
    let khm: String
    let engLowerCase: String
    let lhmLowerCase: String

    enum CodingKeys: String, CodingKey {
        case eng = "ENG"
        case khm = "KHM"
        case engLowerCase = "ENGLowerCase"
        case lhmLowerCase = "KHMLowerCase"
    }
}

extension Place: Coordinated { }
extension Place: Codable { }
extension Place: Equatable { }
