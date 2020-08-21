//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

class ModalView: UIView {
    
    weak var blockedView: UIView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let superResult = super.hitTest(point, with: event)
        return superResult != nil && superResult != self
            ? superResult
            : blockedView?.hitTest(point, with: event)
    }
    
}
