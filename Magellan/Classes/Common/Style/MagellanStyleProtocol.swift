//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

public protocol MagellanStyleProtocol {
    
    /* Fonts */
    var header1Font: UIFont { get }
    var header2Font: UIFont { get }
    var bodyFont: UIFont { get }
    
    /* Text colors */
    var lighterGray: UIColor { get } // #A1A1A0
    var headerColor: UIColor { get } // #2D2926
    var darkTextColor: UIColor { get } // #000000
    var disabledGrayColor: UIColor { get } // #D0D0D0 - disabled gray color
    var descriptionTextColor: UIColor { get } // #75787B - description text color
    var grayTextColor: UIColor { get } //#53565A - gray text color
    var mediumGrayTextColor: UIColor { get } //#797979 - medium gray
    
    /* Background colors*/
    var sectionsDeviderBGColor: UIColor { get } // #F5F5F5 - sectionsDeviderBGColor
    var mainBGColor: UIColor { get } // #FFFFFF - mainBackgroundColor
    var panBGColor: UIColor { get } //#DDDDDD - pan
    
    var firstColor: UIColor { get } // D0021B
    var secondColor: UIColor { get } // #E57901
    
    
    var tableSeparatorInsets: UIEdgeInsets { get }
    var panWidth: CGFloat { get }
    var smallOffset: CGFloat { get }
    var offset: CGFloat { get }
    var doubleOffset: CGFloat { get }
    var topOffset: CGFloat { get }
    var sideOffset: CGFloat { get }
    var buttonSideSize: CGFloat { get }
    var roundedButtonSideSize: CGFloat { get }
}

final class DefaultMagellanStyle: MagellanStyleProtocol {
    
    var header1Font: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    var header2Font: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    var bodyFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
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
