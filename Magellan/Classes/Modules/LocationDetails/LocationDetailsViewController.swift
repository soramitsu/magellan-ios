/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import SoraUI


final class LocationDetailsViewController: UIViewController, LocationDetailsViewProtocol, AdaptiveDesignable {
    
    private let style: MagellanStyleProtocol
    let presenter: LocationDetailsPresenterProtocol
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let headerView = RoundedView()
    private let panView = UIView()
        
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
        view.backgroundColor = .clear
        self.view = view
        
        configureViews()
        layoutViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    private func configureViews() {
        headerView.roundingCorners = [.topLeft, .topRight]
        headerView.cornerRadius = style.topOffset
        headerView.shadowOpacity = 0
        headerView.fillColor = style.backgroundColor

        view.addSubview(headerView)

        panView.backgroundColor = style.dividerColor
        panView.layer.cornerRadius = MapConstants.panHeight / 2
        headerView.addSubview(panView)

        tableView.register(LocationInfoCell.self, forCellReuseIdentifier: LocationInfoCell.reuseIdentifier)
        tableView.register(LocationHeaderCell.self, forCellReuseIdentifier: LocationHeaderCell.reuseIdentifier)
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = style.backgroundColor
        tableView.isScrollEnabled = false

        view.addSubview(tableView)
    }
    
    private func layoutViews() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: style.doubleOffset + 1).isActive = true
        headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.heightAnchor.constraint(equalToConstant: MapConstants.panHeight).isActive = true
        panView.widthAnchor.constraint(equalToConstant: style.panWidth).isActive = true
        panView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        panView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -1).isActive = true
    }
    
    func reload() {
        tableView.reloadData()
    }
}


extension LocationDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items[section].items.count
    }
    
    //swiftlint:disable next force_try
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter.items[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellReusableKey, for: indexPath)
        if let bindable = cell as? Bindable {
            bindable.bind(viewModel: model)
        }

        if let style = style(for: indexPath),
            let styleApplicable = cell as? StyleApplicable {
            styleApplicable.allpy(style: style)
        }

        return cell
    }

    private func style(for indexPath: IndexPath) -> StyleProtocol? {
        let viewModel = presenter.items[indexPath.section].items[indexPath.row]
        switch viewModel {
        case is MapDetailViewModel:
            let isLast = presenter.items[indexPath.section].items.count - 1 == indexPath.row
            return LocationInfoCell.Style(font: style.regular15,
                                          textColor: style.darkColor,
                                          separatorColor:  isLast ? .clear : style.dividerColor)
        case is LocationHeaderViewModel:
            return LocationHeaderCell.Style(titleFont: style.bold20,
                                            commentFont: style.regular15,
                                            bodyFont: style.regular14,
                                            reviewRatingFont: style.semiBold14,
                                            darkColor: style.darkColor,
                                            tintColor: style.primaryColor,
                                            bodyColor: style.grayColor,
                                            ratingDisabledColor: style.dividerColor)
        default:
            return nil
        }
    }

}

extension LocationDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = presenter.items[indexPath.section].items[indexPath.row] as? MapDetailViewModel {
            model.action?()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = presenter.items[section].title else {
            return nil
        }

        let label = UILabel()
        label.text = title
        label.font = style.semiBold15
        label.textColor = style.darkColor

        let containerView = UIView()
        containerView.backgroundColor = tableView.backgroundColor
        containerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: containerView.topAnchor,
                                   constant: style.offset * 2).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                   constant: -style.offset * 2).isActive = true
        label.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                   constant: style.offset * 2).isActive = true
        label.rightAnchor.constraint(equalTo: containerView.rightAnchor,
                                   constant: -style.offset * 2).isActive = true

        return containerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let item = UIView()
        item.backgroundColor = tableView.backgroundColor
        return item
    }


    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return style.offset
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let title = presenter.items[section].title else {
            return .zero
        }

        return UITableView.automaticDimension
    }
}

extension LocationDetailsViewController: ModalDraggable {

    var canDragg: Bool {
        return tableView.contentOffset.y <= 0
    }

    func dismiss() {
        dismiss(animated: true) {
            self.presenter.dismiss()
        }
    }
    
    var draggableView: UIView {
        return view
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

    private var maxAvailableHeight: CGFloat {
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
    
    var fullHeight: CGFloat {
        let contentHeight = headerView.frame.size.height + tableView.contentSize.height
        return min(maxAvailableHeight, contentHeight)
    }
    
    func viewWillChangeFrame(to frame: CGRect) {
        tableView.isScrollEnabled = (frame.size.height - frame.origin.y) >= maxAvailableHeight
            && tableView.frame.size.height < tableView.contentSize.height
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.origin.y, right: 0)
    }

    func didSetup(gesture: UIPanGestureRecognizer) {
        gesture.delegate = self
    }
}

extension LocationDetailsViewController: NavigationBarHiding {}


extension LocationDetailsViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.view?.isDescendant(of: view) == true
    }

}

