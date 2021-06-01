//
/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */


import Foundation

protocol BindableViewModelProtocol: CellViewModelProtocol {
    
    func bind(to cell: UITableViewCell)
        
    func expand(cell: UITableViewCell?, in tableView: UITableView, at indexPath: IndexPath)
}
extension BindableViewModelProtocol {
    
    func expand(cell: UITableViewCell?, in tableView: UITableView, at indexPath: IndexPath) {}
    
    func bind(to cell: UITableViewCell, at indexPath: IndexPath) {
        bind(to: cell)
    }
}

final class PlaceReviewDataSource: NSObject, PlaceReviewDataSourceProtocol {
    
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
        items.append(makeReviewSummary(for: model))
        items.append(makeReviews(for: model))
        
        setupContent()
    }

    private func makeReviewSummary(for model: PlaceReviewViewModel) -> HeaderFooterViewModelProtocol {
        let rateItem = RateViewModel(style: style,
                                     score: model.score,
                                     reviewCount: model.reviewCount)
        let controlItem = ControlCellViewModel(style: style, title: "Rate this place")
        let items: [BindableViewModelProtocol] = [rateItem, controlItem]
        return ReviewSectionViewModel(title: "Review summary",
                                      items: items,
                                      style: style)
    }

    private func makeReviews(for model: PlaceReviewViewModel) -> HeaderFooterViewModelProtocol {
        let s = Array(repeating: CommentViewModel(style: style, fullName: "", rate: 3.0, date: Date()), count: 3)
        let longItem = CommentViewModel(style: style, fullName: "", rate: 3.0, date: Date(), text: "St. Christopher's Inn is in the best location in all of Berlin. You are within walking distance to the Spree Promenade, Museum Insel and, in the other direction you are within walking distance to the Berlin Hauptbahnhof...St. Christopher's Inn is in the best location in all of Berlin. You are within walking distance to the Spree Promenade, Museum Insel and, in the other direction you are within walking distance to the Berlin Hauptbahnhof...", avatarURL: nil)
        var items: [BindableViewModelProtocol] = Array(repeating: CommentViewModel(style: style, fullName: "", rate: 3.0, date: Date()), count: 2)
        items.append(longItem)
        items.append(contentsOf: s)
        return ReviewSectionViewModel(title: "Reviews",
                                      items: items,
                                      style: style)
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
        model.bind(to: cell, at: indexPath)
        return cell
    }
    
}

extension PlaceReviewDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = items[section]
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: model.reusableKey)
            .map { model.bind(to: $0) }
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        200.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        48.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = items[indexPath.section].items[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        model.expand(cell: cell, in: tableView, at: indexPath)
    }
}
