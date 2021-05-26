//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol HeaderFooterViewModelProtocol: ViewModelProtocol {
    var viewType: UITableViewHeaderFooterView.Type { get }
}

extension HeaderFooterViewModelProtocol {
    var reusableKey: String { viewType.reuseIdentifier }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String { String(describing: self) }
}
