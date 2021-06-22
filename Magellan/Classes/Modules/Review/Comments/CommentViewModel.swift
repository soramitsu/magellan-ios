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
    let date: String
    let text: String
    var avatarURL: String?
    var estimatedHeight: CGFloat { 188.0 }
    
    var title: String { fullName }
    var shortTitle: String? { title.shortUppercased }
    var message: String { text }
    var creationDate: String {
        CompoundDateFormatterBuilder()
            .build(defaultFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")
            .date(from: date)
            .map {
                CompoundDateFormatterBuilder()
                    .build(defaultFormat: "dd MMM yyyy")
                    .string(from: $0)
            } ?? ""
    }
    var cellType: UITableViewCell.Type { Cell.self }
    
    func bind(to cell: UITableViewCell) {
        (cell as? Cell).map {
            $0.bind(viewModel: self)
            Cell.Default(style: style).apply(to: $0)
        }
    }
    
    func expand(cell: UITableViewCell?, in tableView: UITableView) {
        (cell as? Cell).map {
            guard $0.expandingView.shouldExpand(to: text) else { return }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}
