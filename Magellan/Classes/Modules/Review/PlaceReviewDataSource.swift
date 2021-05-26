//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

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
