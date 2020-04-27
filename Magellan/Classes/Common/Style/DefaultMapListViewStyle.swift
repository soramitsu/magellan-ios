/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit

public protocol MapListViewStyleProtocol {
    var viewBackgroundColor: UIColor { get }
    var panViewBackgroundColor: UIColor { get }
    var searchFieldFont: UIFont { get }// .styleFont(for: .body)
    var closeButtonTitleLabelFont: UIFont { get } // = .styleFont(for: .title2)
    var tableViewSeparatorInset: UIEdgeInsets { get } // = CommonConstants.separatorInset
    var searchImage: UIImage? { get }
}

final class DefaultMapListViewStyle: MapListViewStyleProtocol {
    var viewBackgroundColor: UIColor = UIColor.Style.background
    var panViewBackgroundColor: UIColor = UIColor.Style.pan
    var searchFieldFont: UIFont = .styleFont(for: .body)
    var closeButtonTitleLabelFont: UIFont = .styleFont(for: .title2)
    var tableViewSeparatorInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    lazy var searchImage: UIImage? = {
        return UIImage(named: "search", in: Bundle.frameworkBundle, compatibleWith: nil)
    }()
}
