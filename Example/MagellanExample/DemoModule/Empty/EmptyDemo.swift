//
//  EmptyDemo.swift
//  MagellanExample
//
//  Created by Iskander Foatov on 14.04.2020.
//  Copyright © 2020 Iskander Foatov. All rights reserved.
//

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
