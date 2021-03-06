//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

protocol ListModelProtocol {
    
    var dataSource: UITableViewDataSource { get }
    var delegate: UITableViewDelegate? { get }
    
    func viewDidLoad()
}

class ListViewController: UIViewController, ListViewProtocol {
    
    let model: ListModelProtocol
    let style: MagellanStyleProtocol
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(model: ListModelProtocol, style: MagellanStyleProtocol) {
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
        model.viewDidLoad()
    }
    
    private func layoutViews() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    private func configureViews() {
        
        tableView.dataSource = model.dataSource
        tableView.delegate = model.delegate
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
}

protocol ListViewProtocol: AnyObject {
    
    var tableView: UITableView { get }
    
    func reloadData()
}

extension ListViewProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}
