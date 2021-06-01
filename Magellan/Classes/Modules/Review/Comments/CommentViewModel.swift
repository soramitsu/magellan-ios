//
/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */


import Foundation
import SoraFoundation

struct CommentViewModel<Cell: CommentTableViewCell>: CommentViewModelProtocol {
    
    let style: MagellanStyleProtocol
    let fullName: String
    let rate: Double
    let date: Date
    var text: String = "The best latte I’ve had in Phnom Penh, one of the best of any I’ve had elsewhere. Nice ambiance, good decor."
    var avatarURL: String?
    var shortTitle: String? { title.shortUppercased }
    var message: String { text }
    var creationDate: String {
        CompoundDateFormatterBuilder(baseDate: date, calendar: .current)
            .build(defaultFormat: "dd MMM yyyy")
            .string(from: date)
    }        
    var cellType: UITableViewCell.Type { Cell.self }
    
    func bind(to cell: UITableViewCell) {
        (cell as? Cell).map {
            $0.bind(viewModel: self)
            Cell.Default(style: style).apply(to: $0)
        }
    }
    
    func expand(cell: UITableViewCell?, in tableView: UITableView, at indexPath: IndexPath) {
        (cell as? Cell).map {
            guard $0.expandingView.shouldExpand(to: text) else { return }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}
