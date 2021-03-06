//
/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */


import Foundation

protocol PlaceReviewDataSourceProtocol: UITableViewDataSource, UITableViewDelegate {
    
    @discardableResult
    func apply(_ model: PlaceInfo) -> [HeaderFooterViewModelProtocol]
}

final class PlaceReviewDataSource: NSObject, PlaceReviewDataSourceProtocol {
    
    weak var view: ListViewProtocol?
    weak var presenter: ReviewsPresenterProtocol?
    let style: MagellanStyleProtocol
    let localizables: LocalizedResourcesFactoryProtocol
    private(set) var items: [HeaderFooterViewModelProtocol] = []
    
    init(view: ListViewProtocol? = nil,
         style: MagellanStyleProtocol,
         localizables: LocalizedResourcesFactoryProtocol,
         items: [HeaderFooterViewModelProtocol] = []) {
        self.view = view
        self.style = style
        self.localizables = localizables
        self.items = items
    }
    
    func apply(_ model: PlaceInfo) -> [HeaderFooterViewModelProtocol] {
        
        items.removeAll()
        items.append(makeReviewSummary(for: model))
        makeReviews(for: model).map { items.append($0) }
        
        setupContent()
        
        return items
    }
    
    func appendAllReviews(_ reviews: [Review]) -> [HeaderFooterViewModelProtocol] {

        var reviews: [BindableViewModelProtocol] = reviews.map {
            CommentViewModel(style: style,
                             fullName: $0.createdByName,
                             rate: $0.score,
                             date: $0.createTime,
                             text: $0.text)
        }
        
        let commentSection = ReviewSectionViewModel(title: localizables.reviews,
                                                    items: reviews,
                                                    style: style)
        
        items = items.dropLast()
        items.append(commentSection)
        
        return items
    }

    private func makeReviewSummary(for model: PlaceInfo) -> HeaderFooterViewModelProtocol {
        
        // Backend implementation needed
        let reviewCount = 0
        
        var rateItem = RateViewModel(style: style,
                                     score: model.score ?? 0,
                                     reviewCount: reviewCount,
                                     margins: .zero)
        
        var items: [BindableViewModelProtocol] = []

        if let userReview = model.review?.userReview {
            rateItem.margins = .init(top: 0, left: 0, bottom: 16.0, right: 0)
            items.append(rateItem)
            items.append(CommentViewModel(style: style,
                                          fullName: userReview.createdByName,
                                          rate: userReview.score,
                                          date: userReview.createTime,
                                          text: userReview.text))
        } else {
            let controlItem = ControlCellViewModel(style: style, title: localizables.ratePlace)
            items.append(rateItem)
            items.append(controlItem)
        }
        
        return ReviewSectionViewModel(title: localizables.reviewSummary,
                                      items: items,
                                      style: style)
    }

    private func makeReviews(for model: PlaceInfo) -> HeaderFooterViewModelProtocol? {
        
        model.review.map {
            $0.latestReviews.map {
                CommentViewModel(style: style,
                                 fullName: $0.createdByName,
                                 rate: $0.score,
                                 date: $0.createTime,
                                 text: $0.text)
            }
        }.map {
            var items: [BindableViewModelProtocol] = $0
            let item = MoreControlCellViewModel(style: style,
                                                title: localizables.showAll) { [weak self] in
                self?.presenter?.loadAllReviews()
            }
            items.append(item)
            return ReviewSectionViewModel(title: localizables.reviews,
                                          items: items,
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
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        46.0
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
        model.select(cell: cell, in: tableView)
    }
}

extension PlaceReviewDataSource {
    class ReviewModel: ListModelProtocol {
        
        let reviewDatasource: PlaceReviewDataSourceProtocol
        let placeProvider: PlaceProvider
        var dataSource: UITableViewDataSource { reviewDatasource }
        var delegate: UITableViewDelegate? { reviewDatasource }
        

        internal init(placeProvider: PlaceProvider, dataSource: PlaceReviewDataSourceProtocol) {
            self.placeProvider = placeProvider
            self.reviewDatasource = dataSource
        }
        
        func loadData() {
            placeProvider.getPlaceInfo(completion: providePlace(_:))
        }
        
        private func providePlace(_ place: PlaceInfo) {
            reviewDatasource.apply(place)
        }

        func viewDidLoad() {
            loadData()
        }
    }
}

