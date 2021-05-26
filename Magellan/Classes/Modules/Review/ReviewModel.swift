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
    
    private func setupContent() {}
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

protocol PlaceProvider {
        
    func getPlaceInfo(completion: @escaping (PlaceInfo) -> Void)
}

final class DemoPlaceProvider: PlaceProvider {

    let service: MagellanServicePrototcol
    var place: PlaceInfo?
    
    internal init(service: MagellanServicePrototcol) {
        self.service = service
    }
    
    func getPlaceInfo(completion: @escaping (PlaceInfo) -> Void) {
        service.getPlace(with: "1", runCompletionIn: .main) { result in
            switch result {
                case .success(let place): break
                    completion(place)
                case.failure(_): break
            }
        }
    }
}

class ReviewModel {
    
    let placeProvider: PlaceProvider
    let dataSource: UITableViewDataSource
    
    internal init(placeProvider: PlaceProvider,
                  dataSource: UITableViewDataSource = PlaceReviewDataSource()) {
        self.placeProvider = placeProvider
        self.dataSource = dataSource
    }
    
    func loadData() {
        
        placeProvider.getPlaceInfo { placeInfo in
            
        }
    }
}

protocol Reviewable {
    var score: Double? { get }
}

public final class ReviewAssembly {
    
    public static func assembly(with resolver: MagellanNetworkResolverProtocol) -> UIViewController {
        
        let operationFactory = MiddlewareOperationFactory(networkResolver: resolver)
        let service = MagellanService(operationFactory: operationFactory)
        let placeProvider = DemoPlaceProvider(service: service)
        let reviewModel = ReviewModel(placeProvider: placeProvider)
        let model = ReviewListModel(reviewModel: reviewModel)
        let style = DefaultMagellanStyle()
        let listController = ListViewController(model: model, style: style)
        let modalController = ModalViewController(rootViewController: listController)
        
        return UINavigationController(rootViewController: modalController)
    }
    
}
