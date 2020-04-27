/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


enum MapDetailError: Error {
    
    case cellNotRegistered
    
}

protocol MapDetailTableHelperDelegate: AnyObject, AutoMockable {
    func hanlde(path: String)
}

protocol MapDetailTableHelperProtocol {
    var place: PlaceInfo { get }
    var items: [MapDetailViewModelProtocol] { get }
    var cellsInUse: [UITableViewCell.Type] { get }
    var delegate: MapDetailTableHelperDelegate? { get set }
    
    func set(placeInfo: PlaceInfo)
    func cell(for model: MapDetailViewModelProtocol,
              in tableView: UITableView,
              indexPath: IndexPath) throws -> UITableViewCell
    func height(for model: MapDetailViewModelProtocol) -> CGFloat
}

final class DefaultMapDetailTableHelper: MapDetailTableHelperProtocol {
    
    weak var delegate: MapDetailTableHelperDelegate?
    
    private(set) var place: PlaceInfo
    private(set) var items: [MapDetailViewModelProtocol] = []
    private let labelInset: CGFloat = UIDevice.isSmallPhone ? 20 : 50
    
    var cellsInUse: [UITableViewCell.Type] {
        [MapDetailCell.self, MapAddressCell.self]
    }
    
    init(place: PlaceInfo) {
        self.place = place
        setupContent()
    }
    
    func setupContent() {
        if let phone = place.phoneNumber.formattedPhone(region: "KH"), !phone.isEmpty {
            let rawPhone = place.phoneNumber
            items.append(MapDetailViewModel(title: L10n.Location.Details.phone,
                                              content: phone,
                                              action: { [weak self] in
                                                self?.delegate?.hanlde(path: "tel://\(rawPhone)")
            }))
        }

        if !place.website.isEmpty {
            let website = place.website
            items.append(MapDetailViewModel(title: L10n.Location.Details.website,
                                              content: place.website,
                                              action: { [weak self] in
                                                self?.delegate?.hanlde(path: website)
            }))
        }

        if !place.facebook.isEmpty {
            let fb = place.facebook
            items.append(MapDetailViewModel(title: L10n.Location.Details.fb,
                                              content: place.facebook,
                                              action: { [weak self] in
                                                self?.delegate?.hanlde(path: fb)
            }))
        }

        if !place.address.isEmpty {
            items.append(MapAddressViewModel(title: L10n.Location.Details.address,
                                               description: place.address))
        }
        

    }
    
    //swiftlint:disable force_cast
    func cell(for model: MapDetailViewModelProtocol,
              in tableView: UITableView,
              indexPath: IndexPath) throws -> UITableViewCell {
        switch model {
        case is MapAddressViewModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapAddressCell.reuseIdentifier,
                                                     for: indexPath) as! MapAddressCell
            cell.viewModel = (model as! MapAddressViewModel)
            return cell
        case is MapDetailViewModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapDetailCell.reuseIdentifier,
                                                     for: indexPath) as! MapDetailCell
            cell.viewModel = (model as! MapDetailViewModel)
            return cell
        default:
            throw MapDetailError.cellNotRegistered
        }
    }
    //swiftlint:enable force_cast
    
    func height(for model: MapDetailViewModelProtocol) -> CGFloat {
        if let addressModel = model as? MapAddressViewModel {
            let descriptionHeight
                = addressModel.description.height(for: UIScreen.main.bounds.width - 2 * labelInset)
            return MapAddressCell.baseHeight + descriptionHeight
        }
        
        return 48
    }
    
    func set(placeInfo: PlaceInfo) { }
}
