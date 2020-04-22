//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit

typealias DemoCompletionBlock = (UIViewController?) -> Void

protocol DemoFactoryProtocol {
    var title: String { get }
    func setupDemo(with completionBlock: @escaping DemoCompletionBlock) throws -> UIViewController
}
