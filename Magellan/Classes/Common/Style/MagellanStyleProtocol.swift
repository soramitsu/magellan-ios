//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

public protocol MagellanStyleProtocol {
    
    var header1Font: UIFont { get }
    var header2Font: UIFont { get }
    var header3Font: UIFont { get }
    var bodyRegularFont: UIFont { get }
    var bodyBoldFont: UIFont { get }
    var smallFont: UIFont { get }
    var bodyTextColor: UIColor { get }
    var headerTextColor: UIColor { get }
    var firstColor: UIColor { get }
    var secondColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var headerBackgroundColor: UIColor { get }
    var panColor: UIColor { get }
    var tableSeparatorInsets: UIEdgeInsets { get }
    var panHeight: CGFloat { get }
    var panWidth: CGFloat { get }
    var offset: CGFloat { get }
    var sideOffset: CGFloat { get }
    var buttonSideSize: CGFloat { get }
    var searchImage: UIImage? { get }
    
}

final class DefaultMagellanStyle: MagellanStyleProtocol {
    
    let header1Font: UIFont = UIFont(name: "GTEestiProText-Medium", size: 19)!
    let header2Font: UIFont = UIFont(name: "GTEestiProDisplay-Regular", size: 15)!
    let header3Font: UIFont = UIFont(name: "GTEestiProText-Regular", size: 15)!
    
    let bodyRegularFont: UIFont = UIFont(name: "GTEestiProText-Regular", size: 13)!
    let bodyBoldFont: UIFont = UIFont(name: "GTEestiProDisplay-Regular", size: 13)!
    let smallFont: UIFont = UIFont(name: "GTEestiProText-Regular", size: 15)!
    
    let bodyTextColor: UIColor = UIColor(red: 0.539, green: 0.539, blue: 0.539, alpha: 1)
    let headerTextColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let firstColor: UIColor = UIColor(red: 0, green: 0.632, blue: 0.402, alpha: 1)
    let secondColor: UIColor = UIColor(red: 0.816, green: 0.008, blue: 0.107, alpha: 1)
    
    let backgroundColor: UIColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    let headerBackgroundColor: UIColor = .white
    let panColor: UIColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1)
    let tableSeparatorInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    let panHeight: CGFloat = MapConstants.panHeight
    let panWidth: CGFloat = 36
    let offset: CGFloat = 4
    let sideOffset: CGFloat = 20
    let buttonSideSize: CGFloat = 40
    
    
    lazy var searchImage: UIImage? = {
        return UIImage(named: "search", in: Bundle.frameworkBundle, compatibleWith: nil)
    }()

}
