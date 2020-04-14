//
//  DemoFactoryProtocol.swift
//  MagellanExample
//
//  Created by Iskander Foatov on 14.04.2020.
//  Copyright © 2020 Iskander Foatov. All rights reserved.
//

import UIKit

typealias DemoCompletionBlock = (UIViewController?) -> Void

protocol DemoFactoryProtocol {
    var title: String { get }
    func setupDemo(with completionBlock: @escaping DemoCompletionBlock) throws -> UIViewController
}
