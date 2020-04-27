/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit


final class LocationDetailsViewController: UIViewController, LocationDetailsViewProtocol {
    
    private let style: LocationDetailsViewStyleProtocol
    var presenter: LocationDetailsPresenterProtocol
    private let tableHelper: MapDetailTableHelperProtocol
    
    private let closeButton = UIButton()
    private let tableView = UITableView()
    private let headerView = UIView()
    private let panView = UIView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let workingHoursLabel = UILabel()
    private let distanceLabel = UILabel()
        
    init(presenter: LocationDetailsPresenterProtocol,
         style: LocationDetailsViewStyleProtocol,
         tableHelper: MapDetailTableHelperProtocol) {
        self.presenter = presenter
        self.style = style
        self.tableHelper = tableHelper
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are incompatible with truth and beauty.")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = style.viewBackgroundColor
        self.view = view
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureHeader() {
        headerView.backgroundColor = style.headerViewBackgroundColor
        view.addSubview(headerView)
        
        panView.backgroundColor = style.panViewBackgroundColor
        panView.layer.cornerRadius = style.panViewCornerRadius
        headerView.addSubview(panView)
        
        nameLabel.font = style.nameLabelFont
        nameLabel.numberOfLines = 0
        nameLabel.text = presenter.place.name
        headerView.addSubview(nameLabel)
        
        categoryLabel.font = style.categoryLabelFont
        categoryLabel.text = presenter.place.type
        categoryLabel.textColor = style.categoryLabelTextColor
        headerView.addSubview(categoryLabel)
        
        // todo: fix this hardcode
        workingHoursLabel.text = "Open until 18:00"
        workingHoursLabel.font = style.workingHoursLabelFont
        workingHoursLabel.textColor = style.workingHoursLabelTextColor
        headerView.addSubview(workingHoursLabel)
        
        distanceLabel.text = presenter.place.distance
        distanceLabel.font = style.distanceFont
        distanceLabel.textColor = style.distanceColor
        headerView.addSubview(distanceLabel)
        
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = .styleFont(for: .title2)
        closeButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        headerView.addSubview(closeButton)
    }
    
    private func configureViews() {
        configureHeader()
        
        tableHelper.cellsInUse.forEach { self.tableView.register($0, forCellReuseIdentifier: $0.reuseIdentifier) }
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorInset = style.separatorInsets
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        view.addSubview(tableView)
    }
    
    private func layoutViews() {

        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.heightAnchor.constraint(equalToConstant: style.panHeight).isActive = true
        panView.widthAnchor.constraint(equalToConstant: style.panWidth).isActive = true
        panView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: style.panHeight).isActive = true
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
        return tableHelper.items.count
    }
    
    //swiftlint:disable next force_try
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableHelper.items[indexPath.row]
        
        return try! tableHelper.cell(for: model, in: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = tableHelper.items[indexPath.row]
        
        return tableHelper.height(for: model)
    }
    
}

extension LocationDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = tableHelper.items[indexPath.row] as? MapDetailViewModel {
            model.action?()
        }
    }
    
}

extension LocationDetailsViewController: NavigationBarHiding {}
