//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct PlaceReviewViewModel {
    
    let place: PlaceInfo
    var score: Double { place.score ?? 0.0 }
    var reviewCount: Int = 39
    
}

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

protocol PlaceProvider {
        
    func getPlaceInfo(completion: @escaping (PlaceInfo) -> Void)
}

protocol PlaceReviewDataSourceProtocol: UITableViewDataSource, UITableViewDelegate {
    
    func provideModel(_ model: PlaceReviewViewModel)
}

class ReviewModel {
    
    let reviewDatasource: PlaceReviewDataSourceProtocol
    let placeProvider: PlaceProvider

    internal init(placeProvider: PlaceProvider, dataSource: PlaceReviewDataSourceProtocol) {
        self.placeProvider = placeProvider
        self.reviewDatasource = dataSource
    }
    
    func loadData() {
        placeProvider.getPlaceInfo(completion: providePlace(_:))
    }
    
    private func providePlace(_ place: PlaceInfo) {
        reviewDatasource.provideModel(.init(place: place))
    }
}

extension ReviewModel: ListModelProtocol {
    
    var dataSource: UITableViewDataSource { reviewDatasource }
    var delegate: UITableViewDelegate? { reviewDatasource }
    
    func viewDidLoad() {
        loadData()
    }
}

protocol Reviewable {
    var score: Double? { get }
    var review: PlaceReview? { get }
}
