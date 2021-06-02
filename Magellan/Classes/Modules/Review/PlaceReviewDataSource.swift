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
        makeReviews(for: model).map {
            items.append($0)
        }
        
        setupContent()
    }

    private func makeReviewSummary(for model: PlaceReviewViewModel) -> HeaderFooterViewModelProtocol {
        let rateItem = RateViewModel(style: style,
                                     score: model.score,
                                     reviewCount: model.reviewCount)
        let controlItem = ControlCellViewModel(style: style, title: "Rate this place")
        var items: [BindableViewModelProtocol] = [rateItem, controlItem]
        model.place.review?.userReview.map {
            items.append(CommentViewModel(style: style,
                                          fullName: $0.createdByName,
                                          rate: $0.score,
                                          date: $0.createTime,
                                          text: $0.text))
        }
        return ReviewSectionViewModel(title: "Review summary",
                                      items: items,
                                      style: style)
    }

    private func makeReviews(for model: PlaceReviewViewModel) -> HeaderFooterViewModelProtocol? {
        
        model.place.review.map {
            $0.latestReviews.map {
                CommentViewModel(style: style,
                                 fullName: $0.createdByName,
                                 rate: $0.score,
                                 date: $0.createTime,
                                 text: $0.text)
            }
        }.map {
            ReviewSectionViewModel(title: "Reviews",
                                   items: $0,
                                   style: style)
        }.map {
            return $0
        }

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
