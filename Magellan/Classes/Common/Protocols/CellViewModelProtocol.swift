//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

protocol CellViewModelProtocol: ViewModelProtocol {
    var cellType: UITableViewCell.Type { get }
}

extension CellViewModelProtocol {
    var cellReusableKey: String {
        return cellType.reuseIdentifier
    }
}
