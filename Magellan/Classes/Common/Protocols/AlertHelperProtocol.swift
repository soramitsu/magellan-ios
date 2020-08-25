//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public protocol AlertHelperProtocol: class {
    func showToast(with message: String, title: String?, action: (title: String, action: () -> Void)?)
}
