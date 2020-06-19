//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

struct CategoryFilterViewModel {

    let category: PlaceCategory
    let locale: Locale
    
    var isSelected: Bool
    
    var name: String {
        if locale.isKm {
            return category.khmerName ?? category.name
        }
        return category.name
    }
    
    var count: String {
        return ""
    }
    
    var image: UIImage {
        guard let image = UIImage(named: "filter_\(category.name.lowercased())", in: Bundle.frameworkBundle, compatibleWith: nil) else {
            return UIImage(named: "filter_other", in: Bundle.frameworkBundle, compatibleWith: nil)!
        }
        
        return image
    }
    
    init(category: PlaceCategory, isSelected: Bool, locale: Locale) {
        self.category = category
        self.isSelected = isSelected
        self.locale = locale
    }
    
}
