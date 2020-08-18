/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


struct MapConstants {
    
    static let panHeight: CGFloat = 5
    static let headerHeight: CGFloat = 64
    static let headerOffset: CGFloat = 8
    static let draggableOffset: CGFloat = 10
    static var categoriesHeight: CGFloat {
        UIScreen.main.bounds.width / 2
    }
    static var listCompactHeight: CGFloat {
        headerHeight + headerOffset + categoriesHeight
    }
    
    static let contentAnimationDuration: TimeInterval = 0.25
}
