/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import MessageUI
import SafariServices


final class LocationDetailsPresenter: NSObject {
    
    weak var view: LocationDetailsViewProtocol?
    weak var delegate: LocationDetailsPresenterDelegate?
    let place: PlaceInfo

    init(placeInfo: PlaceInfo) {
        place = placeInfo
        super.init()
    }
    
}


extension LocationDetailsPresenter: LocationDetailsPresenterProtocol {
    
    var title: String {
        return place.name
    }
    
    var category: String {
        return place.type
    }
    
    var distance: String {
        return place.distance
    }
    
    var workingStatus: String {
        if place.workingSchdule.opens24 {
            return "Open"
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let currentDay = formatter.string(from: date)
        
        guard let shcedule = place
            .workingSchdule
            .workingDays?
            .first(where: { $0.day.lowercased() == currentDay.lowercased() }) else {
                return "Closed"
        }
        
        return "Working hours: \(shcedule.workingHours)"
        
    }
    
    func dismiss() {
        delegate?.dismiss()
    }
    
}

extension LocationDetailsPresenter: MapDetailTableHelperDelegate {
    
    func hanlde(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            guard let controller = view?.controller else {
                return
            }
            controller.present(SFSafariViewController(url: url), animated: true, completion: nil)
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}


extension LocationDetailsPresenter: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
