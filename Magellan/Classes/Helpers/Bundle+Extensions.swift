//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

extension Bundle {
    static var frameworkBundle: Bundle? {
        let frameworkBundle = Bundle(for: MagellanService.self)
        guard let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("Magellan.bundle") else {
            return nil
        }
        
        return Bundle(url: bundleURL)
    }
}
