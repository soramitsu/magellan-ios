/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit
import SoraUI
import SoraFoundation

final class MapListViewController: UIViewController {
    
    let presenter: MapListPresenterProtocol
    private let style: MagellanStyleProtocol
    private let headerView = UIView()
    private let panView = UIView()
    private let searchField = UITextField()
    private let searchContainer = UIView()
    private let tableView = UITableView()
    private var keyboardHandler = KeyboardHandler()
    var erroViewFactory: ErrorViewFactoryProtocol?
    private var errorView: UIView?
    
    private lazy var placeCellStyle: PlaceCell.Style = {
        PlaceCell.Style(nameFont: style.semiBold15,
                        nameColor: style.headerColor,
                        categoryFont: style.regular12,
                        categoryTextColor: style.descriptionTextColor,
                        distanceFont: style.regular12,
                        distanceColor: style.grayTextColor)
    }()
    
    init(presenter: MapListPresenterProtocol, style: MagellanStyleProtocol) {
        self.presenter = presenter
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are incompatible with truth and beauty.")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = style.sectionsDeviderBGColor
        self.view = view
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        configureViews()
        layoutViews()
        configureKeyboardHandler()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    fileprivate func configureHeader() {
        headerView.backgroundColor = style.mainBGColor
        view.addSubview(headerView)
        
        panView.backgroundColor = style.panBGColor
        panView.layer.cornerRadius = MapConstants.panHeight / 2
        headerView.addSubview(panView)
        
        searchContainer.backgroundColor = style.sectionsDeviderBGColor
        searchContainer.layer.cornerRadius = style.sideOffset
        headerView.addSubview(searchContainer)
        
        searchField.addTarget(self, action: #selector(search(_:)), for: .editingChanged)
        searchField.textColor = style.mediumGrayTextColor
        searchField.font = style.regular13
        searchField.textAlignment = .left
        searchField.clearButtonMode = .whileEditing
        searchField.borderStyle = .none
        searchField.backgroundColor = .clear
        searchField.delegate = self
        searchContainer.addSubview(searchField)
    }
    
    private func configureViews() {
        configureHeader()
        
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.reuseIdentifier)
        tableView.backgroundColor = style.mainBGColor
        tableView.dataSource = self as UITableViewDataSource
        tableView.delegate = self as UITableViewDelegate
        tableView.separatorInset = style.tableSeparatorInsets
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
        panView.widthAnchor.constraint(equalToConstant: style.panWidth).isActive = true
        panView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: MapConstants.panHeight).isActive = true
        panView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.topAnchor.constraint(equalTo: headerView.topAnchor, constant: style.doubleOffset).isActive = true
        searchContainer.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -style.doubleOffset).isActive = true
        searchContainer.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: style.doubleOffset).isActive = true
        searchContainer.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -style.doubleOffset).isActive = true

        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: style.topOffset).isActive = true
        searchField.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: -style.topOffset).isActive = true
        searchField.leftAnchor.constraint(equalTo: searchContainer.leftAnchor, constant: style.sideOffset).isActive = true
        searchField.rightAnchor.constraint(equalTo: searchContainer.rightAnchor, constant: -style.sideOffset).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 1).isActive = true
    }
    
    private func configureKeyboardHandler() {
        keyboardHandler.animateOnFrameChange = { [weak self] frame in
            guard self?.view.window != nil else {
                return
            }
            let bottomInset = frame.origin.y < UIScreen.main.bounds.size.height - 1 ? frame.size.height : 0
            self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        }
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
        } else {
            presenter.dismiss()
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
        cell.style = placeCellStyle
        
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


extension MapListViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.expand()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(textField)
        textField.resignFirstResponder()
        return true
    }
    
}


extension MapListViewController: MapListViewProtocol {
    
    func set(placeholder: String) {
        searchField.placeholder = placeholder
    }
    
    func reloadPlaces() {
        if isViewLoaded
            && view.window != nil {
            errorView?.removeFromSuperview()
            tableView.isHidden = false
            headerView.isHidden = false
            tableView.reloadData()
            view.setNeedsLayout()
        }
    }
    
    func showErrorState(_ retryClosure: @escaping () -> Void) {
        guard let errorView = erroViewFactory?.errorView(with: retryClosure) else {
            return
        }
        tableView.isHidden = true
        headerView.isHidden = true

        
        view.addSubview(errorView)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        errorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        errorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        self.errorView?.removeFromSuperview()
        self.errorView = errorView
    }
}


extension MapListViewController: NavigationBarHiding {}
