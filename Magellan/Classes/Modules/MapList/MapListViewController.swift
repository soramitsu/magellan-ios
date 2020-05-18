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
    private let iconView = UIImageView(image: nil)
    private let searchField = UITextField()
    private let tableView = UITableView()
    private let closeButton = UIButton()
    private var keyboardHandler = KeyboardHandler()
    var erroViewFactory: ErrorViewFactoryProtocol?
    private var errorView: UIView?
    
    private lazy var placeCellStyle: PlaceCell.Style = {
        PlaceCell.Style(nameFont: style.header1Font,
                categoryFont: style.bodyRegularFont,
                categoryTextColor: style.bodyTextColor,
                distanceFont: style.bodyBoldFont,
                distanceColor: style.firstColor)
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
        view.backgroundColor = style.backgroundColor
        self.view = view
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        iconView.image = UIImage(named: "search", in: Bundle.frameworkBundle, compatibleWith: nil)
        
        configureViews()
        layoutViews()
        configureKeyboardHandler()
    }
    
    fileprivate func configureHeader() {
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        
        panView.backgroundColor = style.panColor
        panView.layer.cornerRadius = MapConstants.panHeight / 2
        headerView.addSubview(panView)
        
        iconView.contentMode = .scaleAspectFit
        headerView.addSubview(iconView)
        
        searchField.placeholder = L10n.MapListView.Search.placeholder
        searchField.addTarget(self, action: #selector(search(_:)), for: .editingChanged)
        searchField.textColor = .black
        searchField.font = style.header2Font
        searchField.textAlignment = .left
        searchField.clearButtonMode = .never
        searchField.borderStyle = .none
        searchField.delegate = self
        headerView.addSubview(searchField)
        
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = style.header1Font
        closeButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        headerView.addSubview(closeButton)
    }
    
    private func configureViews() {
        configureHeader()
        
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.reuseIdentifier)
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
        
        self.errorView = errorView
    }
}


extension MapListViewController: NavigationBarHiding {}
