//
/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */


import Foundation

protocol BindableViewModelProtocol: CellViewModelProtocol {
    
    func bind(to cell: UITableViewCell)
}

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

protocol ControlCellViewModelProtocol: BindableViewModelProtocol {
    
    var title: String? { get }
}

struct ControlCellViewModel<Cell: RateControlTableViewCell>: ControlCellViewModelProtocol {
    
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

class PlaceReviewDataSource: NSObject, PlaceReviewDataSourceProtocol {
    
    weak var view: ListViewProtocol?
    let style: MagellanStyleProtocol
    private(set) var items: [HeaderFooterViewModelProtocol] = []
    
    init(view: ListViewProtocol? = nil,
         style: MagellanStyleProtocol,
         items: [HeaderFooterViewModelProtocol] = []) {
        self.view = view
        self.style = style
        self.items = items
    }
    
    func provideModel(_ model: PlaceReviewViewModel) {
        
        items.removeAll()
        
        // make score section
        
        let rateItem = RateViewModel(style: style,
                                     score: model.score,
                                     reviewCount: model.reviewCount)
        let controlItem = ControlCellViewModel(style: style, title: "Rate this place")
        let scoreItems: [BindableViewModelProtocol] = [rateItem, controlItem]
        
        items.append(ReviewSectionViewModel(title: "Review summary", items: scoreItems,
                                            style: style))
        
        // make reviews section
        
        var reviewItems = [BindableViewModelProtocol]()
        
        // append reviews collection
        
        items.append(ReviewSectionViewModel(title: "Reviews", items: reviewItems,
                                            style: style))
        
        setupContent()
    }
    
    private func setupContent() {
        items.forEach(registerHeaderFooter(_:))
        items.flatMap { $0.items }.forEach(registerCells(_:))
        view?.reloadData()
    }
    
    private func registerHeaderFooter(_ viewModel: HeaderFooterViewModelProtocol) {
        view?.tableView.register(viewModel.viewType,
                                 forHeaderFooterViewReuseIdentifier: viewModel.reusableKey)
    }
    
    private func registerCells(_ viewModel: CellViewModelProtocol) {
        view?.tableView.register(viewModel.cellType,
                                 forCellReuseIdentifier: viewModel.cellReusableKey)
    }
}

extension PlaceReviewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = items[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellReusableKey,
                                                 for: indexPath)
        model.bind(to: cell)
        return cell
    }
    
}

extension PlaceReviewDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = items[section]
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: model.reusableKey)
            .map { model.bind(to: $0) }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
