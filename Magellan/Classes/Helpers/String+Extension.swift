//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import libPhoneNumber_iOS

extension String {
    
    func height(for width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(for height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

extension String {
    
    func formattedPhone(region: String) -> String? {
        let phoneUtil = NBPhoneNumberUtil()
        
        guard let phoneNumber = try? phoneUtil.parse(self, defaultRegion: region) else {
            return nil
        }

        return try? phoneUtil.format(phoneNumber, numberFormat: .INTERNATIONAL)
    }
}
