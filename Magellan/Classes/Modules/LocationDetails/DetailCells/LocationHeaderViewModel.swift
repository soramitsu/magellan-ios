//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct LocationHeaderViewModel {

    let place: PlaceInfo
    let localizator: LocalizedResourcesFactoryProtocol

    var title: String {
        return place.name
    }

    var comment: String {
        var type: String
        if localizator.locale.isKm,
            let khmerType = place.khmerType {
            type = khmerType
        } else {
            type = place.type
        }

        if !place.address.isEmpty {
            return "\(type) · \(place.address)"
        }
        return type
    }

    var rating: Double? {
        return nil
    }

    var reviewsCount: Int? {
        return nil
    }

    var status: String? {
        if place.workSchedule?.open24 == true {
            return nil
        }
        // todo: add Closes soon state
        return place.isOpen ? localizator.open : localizator.closed
    }

    var subStatus: String? {
        let resources = WorkingStatusResources(opened: localizator.open,
                                               closed: localizator.closed,
                                               openedTill: localizator.openTill,
                                               closedTill: localizator.closedTill)
        return place.workingStatus(with: resources)
    }

}

extension LocationHeaderViewModel: CellViewModelProtocol {
    var cellType: UITableViewCell.Type {
        return LocationHeaderCell.self
    }
}
