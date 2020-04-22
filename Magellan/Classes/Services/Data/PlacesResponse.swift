//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public struct PlacesResponse: Codable {
    let locations: [Place]
    let clusters: [Cluster]
}
