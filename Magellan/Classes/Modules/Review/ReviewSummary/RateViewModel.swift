//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol RateViewModelProtocol: BindableViewModelProtocol {
    var rate: Double { get }
    var comment: String { get }
    var margins: UIEdgeInsets { get }
}
extension RateViewModelProtocol {
    var margins: UIEdgeInsets { .zero }
}

struct RateViewModel<Cell: RateTableViewCell>: RateViewModelProtocol {
    
    let style: MagellanStyleProtocol
    let score: Double
    let reviewCount: Int
    var margins: UIEdgeInsets 
    
    var cellType: UITableViewCell.Type { Cell.self }
    var rate: Double { score }
    // TODO: Number of reviews implementation needed from backend
    var comment: String { "" }
    
    func bind(to cell: UITableViewCell) {
        (cell as? Cell).map {
            $0.bind(viewModel: self)
            Cell.Default(style: style).apply(to: $0)
        }
    }
}
