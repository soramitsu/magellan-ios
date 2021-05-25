//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

class ReviewDataSource: NSObject {}

extension ReviewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

class ReviewModel {
    
    let place: Reviewable?
    let dataSource: ReviewDataSource
    
    internal init(place: Reviewable? = nil, dataSource: ReviewDataSource = ReviewDataSource()) {
        self.place = place
        self.dataSource = dataSource
    }
}

protocol Reviewable {
    var score: Double { get }
}

public final class ReviewAssembly {
    
    public static func assemble() -> UIViewController {
        let reviewModel = ReviewModel()
        let model = ListModel(dataSource: reviewModel.dataSource)
        let style = DefaultMagellanStyle()
        return ListViewController(model: model, style: style)
    }
    
}
