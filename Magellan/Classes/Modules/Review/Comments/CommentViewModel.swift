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
    
    var title: String { fullName }
    var shortTitle: String? { title.shortUppercased }
    var message: String { text }
    var creationDate: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        let date = formatter.date(from: date)
//        CompoundDateFormatterBuilder()
//            .build(defaultFormat: "dd MMM yyyy")
//            .string(from: date)
        return ""
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
