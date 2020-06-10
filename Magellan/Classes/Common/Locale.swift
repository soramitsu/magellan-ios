//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

enum Locale: String {
    
    case en
    case km
    
    var isKm: Bool {
        return self == Locale.km
    }
}
