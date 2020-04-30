//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public protocol PhoneFormatterProtocol {
    func formattedPhoneNumber(with phone: String, region: String?) -> String?
}
