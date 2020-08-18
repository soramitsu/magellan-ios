//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol SectionViewModelProtocol {
    var title: String? { get }
    var items: [CellViewModelProtocol] { get }
}

extension SectionViewModelProtocol {
    var count: Int {
        return items.count
    }
}
