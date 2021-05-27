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
    var comment: String { "(\(reviewCount))" }
    
    func bind(to cell: UITableViewCell) {
        (cell as? Cell)?.bind(viewModel: self)
        (cell as? Cell)?.apply(style: Cell.Style(style: style))
    }
}

struct RateControlViewModel: BindableViewModelProtocol {
    var cellType: UITableViewCell.Type { RateControlTableViewCell.self }
    
    func bind<Cell>(to cell: Cell) where Cell : UITableViewCell {}
}

class PlaceReviewDataSource: NSObject, PlaceReviewDataSourceProtocol {
    
    weak var view: ListViewProtocol?
    let style: MagellanStyleProtocol
    private(set) var items: [ReviewSectionViewModel] = []
    
    init(view: ListViewProtocol? = nil,
         style: MagellanStyleProtocol,
         items: [ReviewSectionViewModel] = []) {
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
        let scoreItems: [BindableViewModelProtocol] = [rateItem, RateControlViewModel()]
        
        items.append(ReviewSectionViewModel(title: "Review summary", items: scoreItems))
        
        // make reviews section
        
        var reviewItems = [BindableViewModelProtocol]()
        
        // append reviews collection
        
        items.append(ReviewSectionViewModel(title: "Reviews", items: reviewItems))
        
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
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: model.reusableKey)
        (view as? Bindable)?.bind(viewModel: model)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
