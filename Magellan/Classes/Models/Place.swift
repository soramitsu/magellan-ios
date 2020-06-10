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
    let khmerType: String?
    let coordinates: Coordinates
}

extension Place: Coordinated { }
extension Place: Codable { }
extension Place: Equatable { }
