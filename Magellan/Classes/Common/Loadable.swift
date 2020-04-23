//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import UIKit
import SVProgressHUD


protocol Loadable {

    var loadingPresenter: UIViewController? { get }
    func showLoading()
    func hideLoading()
    
}


extension Loadable where Self: UIViewController {
    
    var loadingPresenter: UIViewController? {
        return self
    }
    
}


extension Loadable {
    
    func showLoading() {
        loadingPresenter?.view.endEditing(true)
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
}
