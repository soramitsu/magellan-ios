//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct ResultStatueError: Error {
    
    let code: Int
    let message: String?
    
    init(with status: StatusData) {
        code = status.code
        message = status.error
    }
}
