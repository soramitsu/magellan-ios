//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

class ModalView: UIView {
    
    weak var blockedView: UIView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = blockedView?.hitTest(point, with: event) {
            return view
        }
        return super.hitTest(point, with: event)
    }
    
}
