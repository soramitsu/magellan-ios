//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

extension String {
    
    var shortUppercased: String {
        components(separatedBy: .whitespaces)
            .compactMap {
                $0.first.map { String($0) }
            }.joined()
    }
    
}
