//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct PlaceReviewViewModel {
    
    let place: PlaceInfo
    var score: Double { place.score ?? 0.0 }
    
}

struct ReviewSectionViewModel: HeaderFooterViewModelProtocol {
    let title: String?
    var items: [CellViewModelProtocol]
    var viewType: UITableViewHeaderFooterView.Type { UITableViewSectionHeader.self }
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
}
