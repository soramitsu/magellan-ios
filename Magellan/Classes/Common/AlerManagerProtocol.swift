//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


public protocol AlertManagerProtocol {
    
    func showActionSheet(viewController: UIViewController,
                                title: String,
                                message: String,
                                actions: [(String, UIAlertAction.Style)],
                                completion: ((_ index: Int) -> Void)?)
    
    func showAlert(viewController: UIViewController,
                          title: String,
                          message: String,
                          actions: [(String, UIAlertAction.Style)],
                          completion: ((_ index: Int) -> Void)?)
}

