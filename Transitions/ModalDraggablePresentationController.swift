//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

protocol ModalDraggable {
    var preferredContentHeight: CGFloat { get }
}

class ModalDraggablePresentationViewController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        
        if let modalDraggable = presentedViewController as? ModalDraggable {
            return CGRect(x: 0,
                          y: bounds.height - modalDraggable.preferredContentHeight,
                          width: bounds.size.width,
                          height: bounds.size.height)
        }
        return CGRect(x: 0,
                      y: bounds.size.height / 2,
                      width: bounds.size.width,
                      height: bounds.size.height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }
    
}
