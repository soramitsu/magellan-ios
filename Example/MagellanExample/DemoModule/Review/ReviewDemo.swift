//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import Magellan

struct ReviewDemo: DemoFactoryProtocol {
    
    var title: String { "Reviews Demo" }
    
    func setupDemo(with completionBlock: @escaping DemoCompletionBlock) throws -> UIViewController {
        return ReviewAssembly.assemble()
    }
}
