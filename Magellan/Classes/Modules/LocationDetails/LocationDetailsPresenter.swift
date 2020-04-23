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
