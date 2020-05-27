//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import Magellan


final class DemoMagellanStyle: MagellanStyleProtocol {

    var header1Font: UIFont = UIFont(name: "Sora-SemiBold", size: 15)!
    var header2Font: UIFont = UIFont(name: "Sora-Regular", size: 15)!
    var bodyFont: UIFont = UIFont(name: "Sora-Regular", size: 13)!
    
    var lighterGray: UIColor = UIColor(red: 161/255, green: 161/255, blue: 160/255, alpha: 1)
    var headerColor: UIColor = UIColor(red: 45/255, green: 41/255, blue: 38/255, alpha: 1)
    var darkTextColor: UIColor = .black
    var disabledGrayColor: UIColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
    var descriptionTextColor: UIColor = UIColor(red: 117/255, green: 120/255, blue: 123/255, alpha: 1)
    var grayTextColor: UIColor = UIColor(red: 83/255, green: 86/255, blue: 90/255, alpha: 1)
    var mediumGrayTextColor: UIColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1)
    
    var sectionsDeviderBGColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    var mainBGColor: UIColor = .white
    var panBGColor: UIColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
    
    var firstColor: UIColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1)
    var secondColor: UIColor = UIColor(red: 229/255, green: 121/255, blue: 1/255, alpha: 1)
    

    let tableSeparatorInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    let panWidth: CGFloat = 35
    let smallOffset: CGFloat = 5
    let offset: CGFloat = 7
    let doubleOffset: CGFloat = 15
    let topOffset: CGFloat = 10
    let sideOffset: CGFloat = 20
    let buttonSideSize: CGFloat = 40
    let roundedButtonSideSize: CGFloat = 32
}

