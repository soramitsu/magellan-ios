//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct CategoryFilterViewModel {

    private let category: PlaceCategory
    
    var name: String {
        return category.name
    }
    
    var count: String {
        return ""
    }
    
    var image: UIImage {
        guard let image = UIImage(named: "map_\(category.name.lowercased())", in: Bundle.frameworkBundle, compatibleWith: nil) else {
            return UIImage(named: "map_other", in: Bundle.frameworkBundle, compatibleWith: nil)!
        }
        
        return image
    }
    
    init(category: PlaceCategory) {
        self.category = category
    }
    
}
