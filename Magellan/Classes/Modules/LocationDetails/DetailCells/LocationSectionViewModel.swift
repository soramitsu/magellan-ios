/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct LocationSectionViewModel {
    let title: String?
    var header: HeaderFooterViewModelProtocol?
    var items: [CellViewModelProtocol]
}
