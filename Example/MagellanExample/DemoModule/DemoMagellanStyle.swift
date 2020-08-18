//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit
import Magellan


final class DemoMagellanStyle: MagellanStyleProtocol {
    
    private static let regular = "Sora-Regular"
    private static let bold = "Sora-Bold"
    private static let semiBold = "Sora-SemiBold"
    
    var bold16 = UIFont(name: DemoMagellanStyle.bold, size: 16)!
    var semiBold14 = UIFont(name: DemoMagellanStyle.semiBold, size: 14)!
    var semiBold13 = UIFont(name: DemoMagellanStyle.semiBold, size: 13)!
    var semiBold12 = UIFont(name: DemoMagellanStyle.semiBold, size: 12)!
    var semiBold10 = UIFont(name: DemoMagellanStyle.semiBold, size: 10)!
    var regular13 = UIFont(name: DemoMagellanStyle.regular, size: 13)!
    var regular12 = UIFont(name: DemoMagellanStyle.regular, size: 12)!
    
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

    // MARK: new properties

    let bold20: UIFont = UIFont(name: DemoMagellanStyle.bold, size: 20)!
    var semiBold15 = UIFont(name: DemoMagellanStyle.semiBold, size: 15)!
    let regular15: UIFont = UIFont(name: DemoMagellanStyle.regular, size: 15)!
    let regular14: UIFont = UIFont(name: DemoMagellanStyle.regular, size: 14)!

    var backgroundColor: UIColor = .white
    var darkColor: UIColor = UIColor(red: 0.176, green: 0.161, blue: 0.149, alpha: 1)
    var grayColor: UIColor = UIColor(red: 0.631, green: 0.631, blue: 0.627, alpha: 1)
    var dividerColor: UIColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1)
    var primaryColor: UIColor = UIColor(red: 0.816, green: 0.008, blue: 0.107, alpha: 1)
}

