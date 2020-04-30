//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import Magellan

final class AlertManager: AlertManagerProtocol {
    
    
    func showActionSheet(viewController: UIViewController,
                                title: String,
                                message: String,
                                actions: [(String, UIAlertAction.Style)],
                                completion: ((_ index: Int) -> Void)?) {
        AlertHelper.showActionSheet(viewController: viewController,
                                    title: title,
                                    message: message,
                                    actions: actions,
                                    completion: completion)
    }
    
    func showAlert(viewController: UIViewController,
                          title: String,
                          message: String,
                          actions: [(String, UIAlertAction.Style)],
                          completion: ((_ index: Int) -> Void)?) {
        AlertHelper.showAlert(viewController: viewController,
                              title: title,
                              message: message,
                              actions: actions,
                              completion: completion)
    }
    
}
