//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

extension UIView {
    
    func makeRound() {
        let mask = CAShapeLayer()
        let path = UIBezierPath(ovalIn: bounds)
        mask.path = path.cgPath
        mask.fillRule = .evenOdd
        layer.mask = mask
    }
    
}
