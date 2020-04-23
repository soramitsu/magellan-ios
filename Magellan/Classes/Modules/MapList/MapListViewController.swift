/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit
import SoraUI
import IQKeyboardManagerSwift


final class MapListViewController: UIViewController {
    
    let presenter: MapListPresenterProtocol
    private let style: MapListViewStyleProtocol
    private let headerView = UIView()
    private let panView = UIView()
    private let iconView = UIImageView(image: nil)
    private let searchField = UITextField()
    private let tableView = UITableView()
    private let closeButton = UIButton()
    private var categoriesView: UICollectionView!
    
    init(presenter: MapListPresenterProtocol, style: MapListViewStyleProtocol) {
        self.presenter = presenter
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are incompatible with truth and beauty.")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = style.viewBackgroundColor
        self.view = view
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        iconView.image = style.searchImage
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureHeader() {
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        
        panView.backgroundColor = style.panViewBackgroundColor
        panView.layer.cornerRadius = MapConstants.panHeight / 2
        headerView.addSubview(panView)
        
        iconView.contentMode = .scaleAspectFit
        headerView.addSubview(iconView)
        
        searchField.placeholder = L10n.MapListView.Search.placeholder
        searchField.addTarget(self, action: #selector(search(_:)), for: .editingChanged)
        searchField.textColor = .black
        searchField.font = style.searchFieldFont
        searchField.textAlignment = .left
        searchField.clearButtonMode = .never
        searchField.borderStyle = .none
        searchField.delegate = self
        headerView.addSubview(searchField)
        
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = style.closeButtonTitleLabelFont
        closeButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        headerView.addSubview(closeButton)
    }
    
    private func configureCategories() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        categoriesView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoriesView.dataSource = self
        categoriesView.delegate = self
        categoriesView.backgroundColor = .white
        categoriesView.register(CategoryCollectionCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionCell.reuseIdentifier)
    }
    
    private func configureViews() {
        configureHeader()
        
        configureCategories()
        
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.reuseIdentifier)
        tableView.dataSource = self as UITableViewDataSource
        tableView.delegate = self as UITableViewDelegate
        tableView.separatorInset = style.tableViewSeparatorInset
        tableView.tableHeaderView = categoriesView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        view.addSubview(tableView)
    }
    
    private func layoutViews() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.heightAnchor.constraint(equalToConstant: MapConstants.panHeight).isActive = true
        panView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        panView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: MapConstants.panHeight).isActive = true
        panView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: panView.bottomAnchor, constant: 20).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12).isActive = true
        closeButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -12).isActive = true

        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        searchField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 12).isActive = true
        searchField.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -12).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 50)
        searchField.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let headerView = tableView.tableHeaderView else {
            return
            
        }
        
        let height = categoriesView.collectionViewLayout.collectionViewContentSize.height
        var headerFrame = headerView.frame

        if height != headerFrame.size.height {
            headerFrame.size.height = height
            headerFrame.size.width = view.frame.width
            headerView.frame = headerFrame
            tableView.tableHeaderView = headerView
            
            tableView.setNeedsLayout()
        }

        headerView.translatesAutoresizingMaskIntoConstraints = true
    }

    @objc private func search(_ textfield: UITextField) {
        if let text = textfield.text, text.count > 3 {
            presenter.search(with: text)
        }
    }
    
    @objc private func dismiss(_ sender: Any) {
        if let text = searchField.text, !text.isEmpty {
            searchField.text = ""
            presenter.search(with: "")
        }
    }
    
}


extension MapListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.reuseIdentifier) as? PlaceCell else {
            fatalError("dequeted cell is not PlaceCell type")
        }
        
        cell.place = presenter.places[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
 
}


extension MapListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        presenter.showDetails(place: presenter.places[indexPath.row])
    }
    
}


extension MapListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.reuseIdentifier,
                                                            for: indexPath) as? CategoryCollectionCell else {
                                                                fatalError("Could not deque catt of type CategoryCollectionCell")
        }

        cell.category = presenter.categories[indexPath.row]

        return cell
    }
    
}


extension MapListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = presenter.categories[indexPath.row]
        searchField.text = category.name
        presenter.select(category: category.name)
    }
    
}


extension MapListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(textField)
        textField.resignFirstResponder()
        return true
    }
    
}


extension MapListViewController: MapListViewProtocol {
    
    func reloadData() {
        if isViewLoaded
            && view.window != nil {
            categoriesView.reloadData()
            tableView.reloadData()
            view.setNeedsLayout()
        }
    }

}


extension MapListViewController: NavigationBarHiding {}
