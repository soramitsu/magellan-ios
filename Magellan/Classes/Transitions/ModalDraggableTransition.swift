//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

class ModalDraggableTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    weak var underlyingView: UIView?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = ModalDraggablePresentationViewController(presentedViewController: presented, presenting: presenting ?? source)
        controller.underlyingView = underlyingView
        return controller
    }
    
}
