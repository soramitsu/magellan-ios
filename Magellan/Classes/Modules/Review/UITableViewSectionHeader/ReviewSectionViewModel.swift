//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol ReviewSectionViewModelProtocol: HeaderFooterViewModelProtocol {
    
    var title: String? { get }
}

struct ReviewSectionViewModel<View: UITableViewSectionHeader>: ReviewSectionViewModelProtocol {

    let title: String?
    let items: [BindableViewModelProtocol]
    let style: MagellanStyleProtocol
    var viewType: UITableViewHeaderFooterView.Type { View.self }

    func bind(to view: UITableViewHeaderFooterView) -> UITableViewHeaderFooterView {
        (view as? View).map {
            $0.bind(viewModel: self)
            View.Default(style: style).apply(to: $0)
        }
        return view
    }
}


