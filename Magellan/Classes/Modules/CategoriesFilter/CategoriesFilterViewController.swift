//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

final class CategoriesFilterViewController: UIViewController {
    
    private struct Constants {
        static let backgroundAlpha: CGFloat = 0.4
        static let backgroundColor: UIColor = .black
        static let tableHeight: CGFloat = UIDevice.isSmallPhone ? 400 : 562
    }
    
    let presenter: CategoriesFilterPresenterProtocol
    
    private let style: MagellanStyleProtocol
    private var containerView: UIView!
    private var tableView: UITableView!
    private var headerView: UIView!
    private var titleLabel: UILabel!
    private var resetButton: UIButton!
    private var panView: UIView!
    
    private lazy var cellStyle: CategoryFilterTableCell.Style = {
        return CategoryFilterTableCell.Style(titleFont: self.style.semiBold14,
                                             titleColor: self.style.darkTextColor,
                                             selectedImage: UIImage(named: "filter_checkmark",
                                                                    in: Bundle.frameworkBundle,
                                                                    compatibleWith: nil)!,
                                             logoBackground: self.style.categoryLabelBackground)
    }()
    
    init(presenter: CategoriesFilterPresenterProtocol, style: MagellanStyleProtocol) {
        self.presenter = presenter
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        configureUI()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    private func configureUI() {
        containerView = UIView()
        containerView.backgroundColor = style.backgroundColor
        headerView = UIView()
        
        headerView.layer.cornerRadius = style.topOffset
        headerView.backgroundColor = style.backgroundColor
        
        panView = UIView()
        panView.backgroundColor = style.dividerColor
        panView.layer.cornerRadius = MapConstants.panHeight / 2
        headerView.addSubview(panView)
        
        titleLabel = UILabel()
        titleLabel.font = style.bold16
        titleLabel.textColor = style.headerColor
        headerView.addSubview(titleLabel)
        
        resetButton = UIButton(type: .custom)
        resetButton.setTitleColor(style.primaryColor, for: .normal)
        resetButton.setTitleColor(style.primaryColor.withAlphaComponent(0.3), for: .disabled)
        resetButton.titleLabel?.font = style.regular14
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        headerView.addSubview(resetButton)
        containerView.addSubview(headerView)
        view.addSubview(containerView)
        
        tableView = UITableView()
        tableView.register(CategoryFilterTableCell.self, forCellReuseIdentifier: CategoryFilterTableCell.reuseIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = style.backgroundColor
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -style.topOffset).isActive = true
        headerView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.heightAnchor.constraint(equalToConstant: MapConstants.panHeight).isActive = true
        panView.widthAnchor.constraint(equalToConstant: style.panWidth).isActive = true
        panView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: MapConstants.panHeight).isActive = true
        panView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: style.doubleOffset).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: style.sideOffset).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -style.doubleOffset).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        resetButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -style.sideOffset).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = style.sectionsDeviderBGColor
        headerView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: Constants.tableHeight).isActive = true
        tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close(sender:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func reset() {
        presenter.resetFilter()
    }
    
    @objc
    private func close(sender: UITapGestureRecognizer) {
        let presenter = self.presenter
        // #crunch animated dismiss will not call completion block of animation if UIViewControllerInteractiveTransitioning of transitionDelegate exist
        self.dismiss(animated: false) {
            presenter.dismiss()
        }
    }
}

extension CategoriesFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterTableCell.reuseIdentifier, for: indexPath) as! CategoryFilterTableCell
        let viewModel = presenter.viewModel(indexPath.row)
        
        cell.style = cellStyle
        cell.viewModel = viewModel
        if viewModel.isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
}

extension CategoriesFilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        presenter.deselect(with: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.select(with: indexPath.row)
    }
}

extension CategoriesFilterViewController: CategoriesFilterViewProtocol {
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(resetTitle: String) {
        resetButton.setTitle(resetTitle, for: .normal)
    }

    func set(resetEnabled: Bool) {
        resetButton.isEnabled = resetEnabled
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}

extension CategoriesFilterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.location(in: containerView).y < 0
    }
}

extension CategoriesFilterViewController: ModalDismissable {
    
    var draggableView: UIView {
        return headerView
    }
    
    func didDismiss() {
        presenter.dismiss()
    }
    
}
