//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import Magellan
import libPhoneNumber_iOS

final class MagellanPhoneFormatter: PhoneFormatterProtocol {
    let phoneUtil = NBPhoneNumberUtil()
    
    func formattedPhoneNumber(with phone: String, region: String?) -> String? {
        guard let phoneNumber = try? phoneUtil.parse(phone, defaultRegion: region) else {
            return nil
        }

        return try? phoneUtil.format(phoneNumber, numberFormat: .INTERNATIONAL)
    }
}
