//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct CommentViewModel<Cell: CommentTableViewCell>: CommentViewModelProtocol {
    
    let style: MagellanStyleProtocol
    let fullName: String
    let rate: Double
    let date: Date
    var text: String = "The best latte I’ve had in Phnom Penh, one of the best of any I’ve had elsewhere. Nice ambiance, good decor."
    var avatarURL: String?
    var shortTitle: String? { title.shortUppercased }
    var message: String { text }
    var isAllowedToExpand: Bool = false
        
    var cellType: UITableViewCell.Type { Cell.self }
    
    func bind(to cell: UITableViewCell) {
        (cell as? Cell).map {
            $0.bind(viewModel: self)
            Cell.Default(style: style).apply(to: $0)
        }
    }
    
    func expand(cell: UITableViewCell?, in tableView: UITableView, at indexPath: IndexPath) {
        (cell as? Cell).map { cell in
            guard cell.strategy.shouldExpand(to: text,
                                           view: cell.expandingView) == true else { return }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

}
