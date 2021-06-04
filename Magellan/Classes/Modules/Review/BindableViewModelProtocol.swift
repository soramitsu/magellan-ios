//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol BindableViewModelProtocol: CellViewModelProtocol {
        
    func bind(to cell: UITableViewCell)
        
    func expand(cell: UITableViewCell?, in tableView: UITableView)
    
    func select(cell: UITableViewCell?, in tableView: UITableView)
}
extension BindableViewModelProtocol {
    
    func select(cell: UITableViewCell?, in tableView: UITableView) {
        expand(cell: cell, in: tableView)
    }
    
    func expand(cell: UITableViewCell?, in tableView: UITableView) {}
}
