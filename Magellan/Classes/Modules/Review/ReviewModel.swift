//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

class UITableViewSectionHeader: UITableViewHeaderFooterView, Bindable {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Header title"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layoutViews()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        contentView.addSubview(titleLabel)
        let bottomAnchor = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.0)
        bottomAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: 14.0),
            bottomAnchor,
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16.0)
        ])
    }
    
    private func configureViews() {
        contentView.backgroundColor = .white
    }
}

extension UITableViewSectionHeader {
    
    func bind(viewModel: ViewModelProtocol) {
        titleLabel.text = (viewModel as? ReviewSectionViewModel)?.title
    }
}

struct PlaceReviewViewModel {
    
    let place: PlaceInfo
    var score: Double { place.score ?? 0.0 }
    
}

protocol HeaderFooterViewModelProtocol: ViewModelProtocol {
    var viewType: UITableViewHeaderFooterView.Type { get }
}

extension HeaderFooterViewModelProtocol {
    var reusableKey: String { viewType.reuseIdentifier }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String { String(describing: self) }
}

struct ReviewSectionViewModel: HeaderFooterViewModelProtocol {
    let title: String?
    var items: [CellViewModelProtocol]
    var viewType: UITableViewHeaderFooterView.Type { UITableViewSectionHeader.self }
}

class PlaceReviewDataSource: NSObject, PlaceReviewDataSourceProtocol {
     
    weak var view: ListViewProtocol?
    private(set) var items: [ReviewSectionViewModel] = []
    
    func provideModel(_ model: PlaceReviewViewModel) {
        
        items.removeAll()
        
        // make score section
        
        items.append(ReviewSectionViewModel(title: "Review summary", items: []))
        
        // make reviews section
        
        var reviewItems = [CellViewModelProtocol]()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellReusableKey, for: indexPath)
        (cell as? Bindable)?.bind(viewModel: model)
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
                case .success(let place):
                    completion(place)
                case.failure(_): break
            }
        }
    }
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

public final class ReviewAssembly {
    
    public static func assembly(with resolver: MagellanNetworkResolverProtocol) -> UIViewController {
        
        let operationFactory = MiddlewareOperationFactory(networkResolver: resolver)
        let service = MagellanService(operationFactory: operationFactory)
        let placeProvider = DemoPlaceProvider(service: service)
        let dataSource = PlaceReviewDataSource()
        let model = ReviewModel(placeProvider: placeProvider, dataSource: dataSource)
        let style = DefaultMagellanStyle()
        let listController = ListViewController(model: model, style: style)
        let modalController = ModalViewController(rootViewController: listController)
        
        dataSource.view = listController
        
        return UINavigationController(rootViewController: modalController)
    }
    
}
