//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

final class CategoriesFilterViewController: UIViewController {
    
    let presenter: CategoriesFilterPresenterProtocol
    
    private let style: MagellanStyleProtocol
    private var containerView: UIView!
    private var tableView: UITableView!
    private var headerView: UIView!
    private var titleLabel: UILabel!
    private var resetButton: UIButton!
    private var panView: UIView!
    
    private lazy var cellStyle: CategoryFilterTableCell.Style = {
        return CategoryFilterTableCell.Style(titleFont: self.style.header2Font,
                                            titleColor: self.style.headerTextColor,
                                            countFont: self.style.header3Font,
                                            countColor: self.style.backgroundColor,
                                            selectedImage: UIImage(named: "checkmark", in: Bundle.frameworkBundle, compatibleWith: nil)!)
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
        configureUI()
        setupConstraints()
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    
    private func configureUI() {
        containerView = UIView()
        containerView.backgroundColor = style.headerBackgroundColor
        headerView = UIView()
        
        headerView.layer.cornerRadius = 10
        headerView.backgroundColor = style.headerBackgroundColor
        
        panView = UIView()
        panView.backgroundColor = style.panColor
        panView.layer.cornerRadius = MapConstants.panHeight / 2
        headerView.addSubview(panView)
        
        titleLabel = UILabel()
        titleLabel.text = L10n.Filter.title
        titleLabel.font = style.header1Font
        titleLabel.textColor = style.headerTextColor
        headerView.addSubview(titleLabel)
        
        resetButton = UIButton(type: .custom)
        resetButton.setTitle(L10n.Filter.reset, for: .normal)
        resetButton.setTitleColor(style.firstColor, for: .normal)
        resetButton.setTitleColor(style.firstColor.withAlphaComponent(0.3), for: .disabled)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        headerView.addSubview(resetButton)
        containerView.addSubview(headerView)
        view.addSubview(containerView)
        
        tableView = UITableView()
        tableView.register(CategoryFilterTableCell.self, forCellReuseIdentifier: CategoryFilterTableCell.reuseIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = style.headerBackgroundColor
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
        headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -10).isActive = true
        headerView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.heightAnchor.constraint(equalToConstant: MapConstants.panHeight).isActive = true
        panView.widthAnchor.constraint(equalToConstant: style.panWidth).isActive = true
        panView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: MapConstants.panHeight).isActive = true
        panView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        resetButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = style.backgroundColor
        headerView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        headerView.addGestureRecognizer(panGesture)
    }
    
    @objc func reset() {
        presenter.resetFilter()
    }
    
    private var deltaTransform: CGFloat = .zero
    @objc
    private func handlePan(sender: UIPanGestureRecognizer) {
        let viewTranslation = sender.translation(in: view)
        deltaTransform += viewTranslation.y
        if deltaTransform < 0 {
            return
        }
        switch sender.state {
        case .changed:
            
            UIView.animate(withDuration: 0.1) {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
                self.tableView.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
            }
        case .ended:
            if viewTranslation.y < 100 {
                UIView.animate(withDuration: 0.1) {
                    self.containerView.transform = .identity
                    self.tableView.transform = .identity
                }
            } else {
                presenter.dismiss()
                self.dismiss(animated: false, completion: nil)
            }
            deltaTransform = 0
        default:
            break
        }
    }

}

extension CategoriesFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterTableCell.reuseIdentifier, for: indexPath) as! CategoryFilterTableCell
        
        cell.viewModel = presenter.viewModel(indexPath.row)
        cell.style = cellStyle
        
        return cell
    }
}

extension CategoriesFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        presenter.deselect(with: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.select(with: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if presenter.isSelected(indexPath.row) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}

extension CategoriesFilterViewController: CategoriesFilterViewProtocol {
    
    func reload() {
        tableView.reloadData()
    }
    
}
