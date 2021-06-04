//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct MoreControlCellViewModel<Cell: MoreControlTableViewCell>: ControlCellViewModelProtocol {
    
    let style: MagellanStyleProtocol
    var cellType: UITableViewCell.Type { Cell.self }
    var title: String?

    func bind(to cell: UITableViewCell) {
        (cell as? Cell).map {
            $0.bind(viewModel: self)
            Cell.Default(style: style).apply(to: $0)
        }
    }
}
