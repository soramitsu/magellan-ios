//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit
import SafariServices

protocol UrlHandlerProtocol {
    func handle(path: String, on controller: UIViewController)
    func handle(url: URL, on controller: UIViewController)
}

extension UrlHandlerProtocol {
    func handle(path: String, on controller: UIViewController) {
        guard let url = URL(string: path) else {
            return
        }
        handle(url: url, on: controller)
    }
    
    func handle(url: URL, on controller: UIViewController) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
