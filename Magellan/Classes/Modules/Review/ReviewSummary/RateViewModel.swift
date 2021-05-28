//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol RateViewModelProtocol: BindableViewModelProtocol {
    var rate: Double { get }
    var comment: String { get }
}

struct RateViewModel<Cell: RateTableViewCell>: RateViewModelProtocol {
    
    let style: MagellanStyleProtocol
    let score: Double
    let reviewCount: Int
    
    var cellType: UITableViewCell.Type { Cell.self }
    var rate: Double { score }
    var comment: String { "(\(reviewCount) reviews)" }
    
    func bind(to cell: UITableViewCell) {
        (cell as? Cell).map {
            $0.bind(viewModel: self)
            Cell.Default(style: style).apply(to: $0)
        }
    }
}
