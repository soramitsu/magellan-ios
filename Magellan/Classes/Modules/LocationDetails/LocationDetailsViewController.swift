/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import SoraUI

final class LocationDetailsViewController: UIViewController, LocationDetailsViewProtocol, AdaptiveDesignable {
    
    private let style: MagellanStyleProtocol
    var presenter: LocationDetailsPresenterProtocol
    
    private let closeButton = UIButton()
    private let tableView = UITableView()
    private let headerView = UIView()
    private let panView = UIView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let workingHoursLabel = UILabel()
    private let distanceLabel = UILabel()
        
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
        view.backgroundColor = style.backgroundColor
        self.view = view
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureHeader() {
        headerView.backgroundColor = style.headerBackgroundColor
        view.addSubview(headerView)
        
        panView.backgroundColor = style.panColor
        panView.layer.cornerRadius = MapConstants.panHeight / 2
        headerView.addSubview(panView)
        
        nameLabel.font = style.header1Font
        nameLabel.numberOfLines = 0
        nameLabel.text = presenter.title
        headerView.addSubview(nameLabel)
        
        categoryLabel.font = style.bodyRegularFont
        categoryLabel.text = presenter.category
        categoryLabel.textColor = style.bodyTextColor
        headerView.addSubview(categoryLabel)
        
        workingHoursLabel.text = presenter.workingStatus
        workingHoursLabel.font = style.bodyBoldFont
        workingHoursLabel.textColor = presenter.isOpen ? style.firstColor : style.secondColor
        headerView.addSubview(workingHoursLabel)
        
        distanceLabel.text = presenter.distance
        distanceLabel.font = style.bodyBoldFont
        distanceLabel.textColor = style.bodyTextColor
        headerView.addSubview(distanceLabel)
        
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = style.header1Font
        closeButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        headerView.addSubview(closeButton)
    }
    
    private func configureViews() {
        configureHeader()
    
        tableView.register(MapDetailCell.self, forCellReuseIdentifier: MapDetailCell.reuseIdentifier)
        tableView.register(MapAddressCell.self, forCellReuseIdentifier: MapAddressCell.reuseIdentifier)
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorInset = style.tableSeparatorInsets
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        view.addSubview(tableView)
    }
    
    private func layoutViews() {

        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.heightAnchor.constraint(equalToConstant: MapConstants.panHeight).isActive = true
        panView.widthAnchor.constraint(equalToConstant: style.panWidth).isActive = true
        panView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: MapConstants.panHeight).isActive = true
        panView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: style.sideOffset).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -style.sideOffset).isActive = true
        nameLabel.topAnchor.constraint(equalTo: panView.bottomAnchor, constant: 4 * style.offset).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.widthAnchor.constraint(equalToConstant: style.buttonSideSize).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: style.buttonSideSize).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -(3 * style.offset)).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2 * style.offset).isActive = true
        
        workingHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        workingHoursLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        workingHoursLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 3 * style.offset).isActive = true
        workingHoursLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -(4 * style.offset)).isActive = true
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.centerYAnchor.constraint(equalTo: workingHoursLabel.centerYAnchor).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: closeButton.rightAnchor).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 2 * style.offset).isActive = true
    }
   
    @objc private func dismiss(_ sender: Any) {
        presenter.dismiss()
    }

}


extension LocationDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    //swiftlint:disable next force_try
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter.items[indexPath.row]
        
        switch model {
        case is MapAddressViewModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapAddressCell.reuseIdentifier,
                                                     for: indexPath) as! MapAddressCell
            cell.viewModel = (model as! MapAddressViewModel)
            cell.style = MapAddressCell.Style(titleFont: style.bodyBoldFont,
                                              addressFont: style.bodyBoldFont,
                                              addressTextColor: style.secondColor)
            return cell
        case is MapDetailViewModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapDetailCell.reuseIdentifier,
                                                     for: indexPath) as! MapDetailCell
            cell.viewModel = (model as! MapDetailViewModel)
            cell.style = MapDetailCell.Style(titleFont: style.bodyBoldFont,
                                             titleTextColor: style.bodyTextColor,
                                             contentFont: style.bodyBoldFont,
                                             contentTextColor: style.secondColor)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = presenter.items[indexPath.row]
        
        let labelInset: CGFloat = isAdaptiveHeightDecreased ? 20 : 50
        if let addressModel = model as? MapAddressViewModel {
            let descriptionHeight = addressModel.description
                .height(for: max(0, tableView.bounds.width - 2 * labelInset),
                        font: style.bodyRegularFont)
            return MapAddressCell.baseHeight + descriptionHeight
        }
        
        return 48
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

extension LocationDetailsViewController: NavigationBarHiding {}
