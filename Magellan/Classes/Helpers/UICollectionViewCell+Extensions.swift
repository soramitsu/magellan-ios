//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit


extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
