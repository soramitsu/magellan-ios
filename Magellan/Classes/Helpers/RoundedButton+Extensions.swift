//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import SoraUI

extension RoundedButton {
    func configureRound(with side: CGFloat,
                        shadowOpacity: CGFloat = 0.36,
                        size: CGSize = CGSize(width: 0, height: 2),
                        fillColor: UIColor = .white) {
        roundedBackgroundView?.cornerRadius = side / 2
        roundedBackgroundView?.shadowOpacity = 0.36
        roundedBackgroundView?.shadowOffset = CGSize(width: 0, height: 2)
        roundedBackgroundView?.fillColor = .white
        roundedBackgroundView?.highlightedFillColor = .white
        changesContentOpacityWhenHighlighted = true
    }
}
