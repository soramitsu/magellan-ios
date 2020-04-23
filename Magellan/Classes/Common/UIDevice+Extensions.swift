/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


enum PhoneType {
    
    case se
    case six
    case plus
    case x
    case xr
    case max
    case unknown
    
    static func type() -> PhoneType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .se
        case 1334:
            return .six
        case 1920, 2208:
            return .plus
        case 2436:
            return .x
        case 2688:
            return.max
        case 1792:
            return .xr
        default:
            return .unknown
        }
    }
    
}


extension UIDevice {
    
    static let isSmallPhone: Bool = {
        return PhoneType.type() == .se || PhoneType.type() == .six
    }()
    
    var os: String {
        return "\(systemName) \(systemVersion)"
    }
    
}
