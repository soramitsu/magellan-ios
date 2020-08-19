//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

public protocol MagellanStyleProtocol {
    
    /* Fonts */
    var bold16: UIFont { get }

    var semiBold14: UIFont { get }
    var semiBold13: UIFont { get }
    var semiBold12: UIFont { get }
    var semiBold10: UIFont { get }
    

    var regular13: UIFont { get }
    var regular12: UIFont { get }
    
    /* Text colors */
    var lighterGray: UIColor { get } // #A1A1A0
    var headerColor: UIColor { get } // #2D2926
    var darkTextColor: UIColor { get } // #000000
    var disabledGrayColor: UIColor { get } // #D0D0D0 - disabled gray color
    var descriptionTextColor: UIColor { get } // #75787B - description text color
    var grayTextColor: UIColor { get } //#53565A - gray text color
    var mediumGrayTextColor: UIColor { get } //#797979 - medium gray
    var sectionsDeviderBGColor: UIColor { get } // #F5F5F5 - sectionsDeviderBGColor

    var panWidth: CGFloat { get }
    var offset: CGFloat { get }
    var doubleOffset: CGFloat { get }
    var topOffset: CGFloat { get }
    var sideOffset: CGFloat { get }
    var roundedButtonSideSize: CGFloat { get }


    // MARK: new properties

    var bold20: UIFont { get }
    var semiBold15: UIFont { get }
    var regular15: UIFont { get }
    var regular14: UIFont { get }


    /// default value: white
    var backgroundColor: UIColor { get }

    /// Default value: #2D2926
    var darkColor: UIColor { get }


    /// Default value: #A1A1A0
    var grayColor: UIColor { get }

    /// Default value: #DDDDDD
    var dividerColor: UIColor { get }

    /// Default value: #D0021B
    var primaryColor: UIColor { get }

    /// Default value #FAE6E8
    var categoryLabelBackground: UIColor { get }

}

final class DefaultMagellanStyle: MagellanStyleProtocol {
    var bold16: UIFont = .systemFont(ofSize: 16, weight: .bold)
    var semiBold14: UIFont = .systemFont(ofSize: 14, weight: .semibold)
    var semiBold13: UIFont = .systemFont(ofSize: 13, weight: .semibold)
    var semiBold12: UIFont = .systemFont(ofSize: 12, weight: .semibold)
    var semiBold10: UIFont = .systemFont(ofSize: 10, weight: .semibold)

    var regular13: UIFont = .systemFont(ofSize: 13, weight: .regular)
    var regular12: UIFont = .systemFont(ofSize: 12, weight: .regular)
    
    var lighterGray: UIColor = UIColor(red: 161/255, green: 161/255, blue: 160/255, alpha: 1)
    var headerColor: UIColor = UIColor(red: 45/255, green: 41/255, blue: 38/255, alpha: 1)
    var darkTextColor: UIColor = .black
    var disabledGrayColor: UIColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
    var descriptionTextColor: UIColor = UIColor(red: 117/255, green: 120/255, blue: 123/255, alpha: 1)
    var grayTextColor: UIColor = UIColor(red: 83/255, green: 86/255, blue: 90/255, alpha: 1)
    var mediumGrayTextColor: UIColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1)
    
    var sectionsDeviderBGColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    

    let tableSeparatorInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    let panWidth: CGFloat = 35
    let smallOffset: CGFloat = 4
    let offset: CGFloat = 8
    let doubleOffset: CGFloat = 16
    let topOffset: CGFloat = 10
    let sideOffset: CGFloat = 20
    let buttonSideSize: CGFloat = 40
    let roundedButtonSideSize: CGFloat = 40

    // MARK: new properties

    let bold20: UIFont = .systemFont(ofSize: 20, weight: .bold)
    let semiBold15: UIFont = .systemFont(ofSize: 15, weight: .semibold)
    let regular15: UIFont = .systemFont(ofSize: 15, weight: .regular)
    let regular14: UIFont = .systemFont(ofSize: 14, weight: .regular)

    var backgroundColor: UIColor = .white
    var darkColor: UIColor = UIColor(red: 0.176, green: 0.161, blue: 0.149, alpha: 1)
    var grayColor: UIColor = UIColor(red: 0.631, green: 0.631, blue: 0.627, alpha: 1)
    var dividerColor: UIColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1)
    var primaryColor: UIColor = UIColor(red: 0.816, green: 0.008, blue: 0.107, alpha: 1)
    var categoryLabelBackground: UIColor = UIColor(red: 0.98, green: 0.902, blue: 0.91, alpha: 1)
}
