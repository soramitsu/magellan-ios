//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

class PlaceReviewDataSource: NSObject {
    
    struct ReviewSectionViewModel {
        let title: String?
        var items: [CellViewModelProtocol]
    }
    
    var place: PlaceInfoViewModel!
    private(set) var items: [ReviewSectionViewModel] = []
    
    private func setupContent() {
        
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellReusableKey, for: indexPath)
        (cell as? Bindable)?.bind(viewModel: model)
        return cell
    }
}

class ReviewModel {
    
    let place: Reviewable?
    let dataSource: UITableViewDataSource
    
    internal init(place: Reviewable? = nil, dataSource: UITableViewDataSource = PlaceReviewDataSource()) {
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
        let listController = ListViewController(model: model, style: style)
        let modalController = ModalViewController(rootViewController: listController)
        return UINavigationController(rootViewController: modalController)
    }
    
}
