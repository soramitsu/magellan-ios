//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


class AlertHelper {
    
    static func showActionSheet(viewController: UIViewController,
                                title: String,
                                message: String,
                                actions: [(String, UIAlertAction.Style)],
                                completion: ((_ index: Int) -> Void)?) {
        showAlert(viewController: viewController,
                  title: title,
                  message: message,
                  style: .actionSheet,
                  actions: actions,
                  completion: completion)
    }
    
    static func showAlert(viewController: UIViewController,
                          title: String,
                          message: String,
                          actions: [(String, UIAlertAction.Style)],
                          completion: ((_ index: Int) -> Void)?) {
        showAlert(viewController: viewController,
                  title: title,
                  message: message,
                  style: .alert,
                  actions: actions,
                  completion: completion)
    }
    
    //swiftlint:disable function_parameter_count
    static func showTextInputAlert(viewController: UIViewController,
                                   title: String? = nil,
                                   subtitle: String? = nil,
                                   text: String? = nil,
                                   actionTitle: String? = "Ok",
                                   cancelTitle: String? = "Cancel",
                                   inputPlaceholder: String? = nil,
                                   inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                   actionHandler: ((_ text: String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            textField.text = text
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { action in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private static func showAlert(viewController: UIViewController,
                                  title: String,
                                  message: String,
                                  style: UIAlertController.Style,
                                  actions: [(String, UIAlertAction.Style)],
                                  completion: ((_ index: Int) -> Void)?) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: style)
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion?(index)
            }
            alertViewController.addAction(alertAction)
        }
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
}
