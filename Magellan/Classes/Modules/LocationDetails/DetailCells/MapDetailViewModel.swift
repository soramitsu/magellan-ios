/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation


typealias Action = () -> Void


protocol MapDetailViewModelProtocol {
    var action: Action? { get }
}


struct MapDetailViewModel: MapDetailViewModelProtocol {
    
    var title: String
    var content: String
    var action: Action?
    
    init(title: String, content: String, action: Action? = nil) {
        self.title = title
        self.content = content
        self.action = action
    }
    
}


struct MapAddressViewModel: MapDetailViewModelProtocol {
    
    var title: String
    var description: String
    var action: Action? {
        return nil
    }
}
