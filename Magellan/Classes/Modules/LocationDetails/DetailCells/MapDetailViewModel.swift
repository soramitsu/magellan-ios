/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit


typealias Action = () -> Void

enum MapDetailViewModelType {
    case phone
    case website
    case facebook
    case address
    case workingHours
}

protocol MapDetailViewModelProtocol: CellViewModelProtocol {
    
    var type: MapDetailViewModelType { get }
    var content: String { get }
    var action: Action? { get }
    var image: UIImage? { get }
    
}

struct MapDetailViewModel: MapDetailViewModelProtocol {
    let type: MapDetailViewModelType
    let content: String
    let action: Action?
    
    var image: UIImage? {
        switch type {
        case .phone:
            return UIImage(named: "placeInfo_call", in: .frameworkBundle, compatibleWith: nil)!
        case .website:
            return UIImage(named: "placeInfo_360", in: .frameworkBundle, compatibleWith: nil)!
        case .facebook:
            return UIImage(named: "placeInfo_external-link", in: .frameworkBundle, compatibleWith: nil)!
        case .address:
            return UIImage(named: "placeInfo_direction", in: .frameworkBundle, compatibleWith: nil)!
        case .workingHours:
            return UIImage(named: "placeInfo_time", in: .frameworkBundle, compatibleWith: nil)!
        }
    }
    
    init(type: MapDetailViewModelType, content: String, action: Action?) {
        self.type = type
        self.content = content
        self.action = action
    }

}

extension MapDetailViewModelProtocol {
    var cellType: UITableViewCell.Type {
        return LocationInfoCell.self
    }
}
