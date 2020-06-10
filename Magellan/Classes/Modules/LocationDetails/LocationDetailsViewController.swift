/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import SoraUI


final class LocationDetailsViewController: UIViewController, LocationDetailsViewProtocol, AdaptiveDesignable {
    
    private let style: MagellanStyleProtocol
    var presenter: LocationDetailsPresenterProtocol
    
    private let tableView = UITableView()
    private let tableHeaderView = UIView()
    
    private let headerView = UIView()
    private let panView = UIView()
    
    
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let workingHoursLabel = UILabel()
    private let distanceLabel = UILabel()
    private let separatorView = UIView()
    private let informationLabel = UILabel()
        
    init(presenter: LocationDetailsPresenterProtocol,
         style: MagellanStyleProtocol) {
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
        
        configureViews()
        layoutViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.origin.y, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let tableHeader = tableView.tableHeaderView {

            let height = tableHeader.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = tableHeader.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                tableHeader.frame = headerFrame
                tableView.tableHeaderView = tableHeader
            }
        }
    }
    
    fileprivate func configureHeader() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = style.topOffset
        tableHeaderView.backgroundColor = style.mainBGColor
        
        headerView.backgroundColor = style.mainBGColor
        view.addSubview(headerView)
        
        panView.backgroundColor = style.panBGColor
        panView.layer.cornerRadius = MapConstants.panHeight / 2
        headerView.addSubview(panView)
        
        nameLabel.font = style.semiBold15
        nameLabel.numberOfLines = 0
        nameLabel.text = presenter.title
        tableHeaderView.addSubview(nameLabel)
        
        categoryLabel.font = style.regular12
        categoryLabel.text = presenter.category
        categoryLabel.textColor = style.descriptionTextColor
        categoryLabel.numberOfLines = 0
        tableHeaderView.addSubview(categoryLabel)
        
        workingHoursLabel.text = presenter.workingStatus
        workingHoursLabel.font = style.regular12
        workingHoursLabel.textColor = presenter.isOpen ? style.firstColor : style.secondColor
        tableHeaderView.addSubview(workingHoursLabel)
        
        distanceLabel.text = presenter.distance
        distanceLabel.font = style.regular12
        distanceLabel.textColor = style.grayTextColor
        tableHeaderView.addSubview(distanceLabel)
        
        separatorView.backgroundColor = style.sectionsDeviderBGColor
        tableHeaderView.addSubview(separatorView)
        
        informationLabel.textColor = style.headerColor
        informationLabel.font = style.semiBold13
        tableHeaderView.addSubview(informationLabel)
    }
    
    private func configureViews() {
        configureHeader()
    
        tableView.register(MapDetailCell.self, forCellReuseIdentifier: MapDetailCell.reuseIdentifier)
        tableView.register(MapAddressCell.self, forCellReuseIdentifier: MapAddressCell.reuseIdentifier)
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorInset = style.tableSeparatorInsets
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        view.addSubview(tableView)
    }
    
    private func layoutViews() {
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.heightAnchor.constraint(equalToConstant: MapConstants.panHeight).isActive = true
        panView.widthAnchor.constraint(equalToConstant: style.panWidth).isActive = true
        panView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: style.offset).isActive = true
        panView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -style.doubleOffset).isActive = true
        panView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor, constant: style.sideOffset).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: tableHeaderView.rightAnchor, constant: -style.sideOffset).isActive = true
        nameLabel.topAnchor.constraint(equalTo: tableHeaderView.topAnchor).isActive = true
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        categoryLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, constant: -(2 * style.sideOffset)).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: style.smallOffset).isActive = true
        
        workingHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        workingHoursLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        workingHoursLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: style.topOffset).isActive = true
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.centerYAnchor.constraint(equalTo: workingHoursLabel.centerYAnchor).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: tableHeaderView.rightAnchor, constant: -style.sideOffset).isActive = true
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: workingHoursLabel.bottomAnchor, constant: style.topOffset).isActive = true
        separatorView.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: tableHeaderView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: style.topOffset).isActive = true
        
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: style.doubleOffset).isActive = true
        informationLabel.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor, constant: -style.doubleOffset).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor, constant: style.doubleOffset).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }
    
    func set(information: String) {
        informationLabel.text = information
    }
    
    func reload() {
        tableView.reloadData()
    }
}


extension LocationDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    //swiftlint:disable next force_try
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter.items[indexPath.row]
        
        switch model.type {
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapAddressCell.reuseIdentifier,
                                                     for: indexPath) as! MapAddressCell
            cell.viewModel = model
            cell.style = MapAddressCell.Style(titleFont: style.regular13,
                                              titleColor: style.lighterGray,
                                              addressFont: style.regular13,
                                              addressTextColor: style.headerColor)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapDetailCell.reuseIdentifier,
                                                     for: indexPath) as! MapDetailCell
            cell.viewModel = (model as! MapDetailViewModel)
            cell.style = MapDetailCell.Style(titleFont: style.regular13,
                                             titleTextColor: style.lighterGray,
                                             contentFont: style.regular13,
                                             contentTextColor: style.headerColor)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = presenter.items[indexPath.row]
        
        if model.type != .address {
            return 48
        }
        
        let labelInset: CGFloat = isAdaptiveHeightDecreased ? 20 : 50
        let descriptionHeight = model.content
            .height(for: max(0, tableView.bounds.width - 2 * labelInset),
                    font: style.regular13)
        
        return MapAddressCell.baseHeight + descriptionHeight
    }
    
}

extension LocationDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = presenter.items[indexPath.row] as? MapDetailViewModel {
            model.action?()
        }
    }
    
}

extension LocationDetailsViewController: ModalDraggable {

    func dismiss() {
        dismiss(animated: true) {
            self.presenter.dismiss()
        }
    }
    
    var draggableView: UIView {
        return headerView
    }
    
    var compactHeight: CGFloat {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return 280
        }
        var height = keyWindow.bounds.size.height / 3
        if #available(iOS 11, *) {
            height -= keyWindow.safeAreaInsets.top
        } else {
            height -= UIApplication.shared.statusBarFrame.height
        }
        
        return height
    }
    
    var fullHeight: CGFloat {
        var topOffset: CGFloat = 0
        if #available(iOS 11.0, *) {
            topOffset += UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        } else {
            topOffset += UIApplication.shared.statusBarFrame.size.height
        }
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return 280
        }
        return keyWindow.bounds.height - topOffset - MapConstants.draggableOffset
    }
    
    func viewWillChangeFrame(to frame: CGRect) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.origin.y, right: 0)
    }
}

extension LocationDetailsViewController: NavigationBarHiding {}
