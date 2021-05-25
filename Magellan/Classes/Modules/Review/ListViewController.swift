//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

final class ListModel {

    let dataSource: UITableViewDataSource
    var delegate: UITableViewDelegate?

    internal init(dataSource: UITableViewDataSource, delegate: UITableViewDelegate? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

class ListViewController: UIViewController {
    
    let model: ListModel
    let style: MagellanStyleProtocol
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(model: ListModel, style: MagellanStyleProtocol) {
        self.model = model
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are incompatible with truth and beauty.")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        configureViews()
        layoutViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func layoutViews() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    private func configureViews() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissController))
        
        tableView.dataSource = model.dataSource
        tableView.delegate = model.delegate
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = style.backgroundColor
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}
