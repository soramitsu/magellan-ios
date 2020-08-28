//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import SoraUI

extension RoundedButton {

    struct ShadowStyle {
        let opacity: Float
        let color: UIColor
        let offset: CGSize
        let radius: CGFloat
    }

    private static let defaultShadowStyle = ShadowStyle(opacity: 0.2,
                                                        color: UIColor(red: 0.141, green: 0.149, blue: 0.161, alpha: 1),
                                                        offset: CGSize(width: 0, height: 4),
                                                        radius: 6)
    func configureRound(with side: CGFloat,
                        fillColor: UIColor = .white,
                        highlightedFillColor: UIColor = .white,
                        changesContentOpacityOnHighlighted: Bool = true,
                        shadowStyle: ShadowStyle = RoundedButton.defaultShadowStyle) {
        roundedBackgroundView?.cornerRadius = side / 2
        roundedBackgroundView?.shapePath
        roundedBackgroundView?.shadowOpacity = shadowStyle.opacity
        roundedBackgroundView?.shadowOffset = shadowStyle.offset
        roundedBackgroundView?.shadowRadius = shadowStyle.radius
        roundedBackgroundView?.fillColor = fillColor
        roundedBackgroundView?.highlightedFillColor = highlightedFillColor
        changesContentOpacityWhenHighlighted = changesContentOpacityOnHighlighted
        roundedBackgroundView?.layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: .zero,
                                                                                   size: CGSize(width: side,
                                                                                                height: side)),
                                                               cornerRadius: side / 2).cgPath
    }
}
