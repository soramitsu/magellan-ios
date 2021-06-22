//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol HeaderFooterViewModelProtocol: ViewModelProtocol {
    var items: [BindableViewModelProtocol] { get }
    var viewType: UITableViewHeaderFooterView.Type { get }
    
    @discardableResult
    func bind(to view: UITableViewHeaderFooterView) -> UITableViewHeaderFooterView
}

extension HeaderFooterViewModelProtocol {
    var reusableKey: String { viewType.reuseIdentifier }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String { String(describing: self) }
}
