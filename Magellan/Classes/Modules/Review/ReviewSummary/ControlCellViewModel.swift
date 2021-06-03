//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol ControlCellViewModelProtocol: BindableViewModelProtocol {
    
    var title: String? { get }
}

struct ControlCellViewModel<Cell: RateControlTableViewCell>: ControlCellViewModelProtocol {
    
    let style: MagellanStyleProtocol
    var cellType: UITableViewCell.Type { Cell.self }
    var estimatedHeight: CGFloat { 150.0 }
    var title: String?

    func bind(to cell: UITableViewCell) {
        (cell as? Cell).map {
            $0.bind(viewModel: self)
            Cell.Default(style: style).apply(to: $0)
        }
    }
}
