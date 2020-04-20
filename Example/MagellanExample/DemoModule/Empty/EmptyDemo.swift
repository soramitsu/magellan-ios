//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit

protocol ModuleDelegate: AnyObject {
    func moduleDidFinish()
}

final class EmptyDemo: DemoFactoryProtocol, ModuleDelegate {
    
    var completion: DemoCompletionBlock?
    
    var title: String {
        return "Empty Demo"
    }
    
    func setupDemo(with completionBlock: @escaping DemoCompletionBlock) throws -> UIViewController {
        completion = completionBlock
        let controller = EmptyViewController()
        controller.delegate = self
        return controller
    }
    
    func moduleDidFinish() {
        completion?(nil)
    }
    
}
