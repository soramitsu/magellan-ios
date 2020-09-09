//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct LocationHeaderViewModel {

    let place: PlaceInfoViewModel
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

        return place.isOpen ? localizator.open : localizator.closed
    }

    var subStatus: String? {
        if place.workSchedule?.open24 == true {
            return localizator.allTimeWorks
        }

        let resources = WorkingStatusResources(open: localizator.open,
                                               closed: localizator.closed,
                                               until: localizator.until,
                                               opens: localizator.opens,
                                               closes: localizator.closes,
                                               reopens: localizator.reopens)
        return place.workingStatus(with: resources)
    }

}

extension LocationHeaderViewModel: CellViewModelProtocol {
    var cellType: UITableViewCell.Type {
        return LocationHeaderCell.self
    }
}
