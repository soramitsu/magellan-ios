//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

extension UIFont {
    
    private static func prefferedFontSize(for textStyle: UIFont.TextStyle) -> CGFloat {
        switch textStyle {
        case .largeNumbers:                 return 55
        case .dot:                          return 38
        case .input:                        return 34
        case .cardNumbers:                  return 30
        case .title1, .welcome:             return 24
        case .pin:                          return 21
        case .title2, .riel:                return 19
        case .button, .buttonThin, .accent: return 17
        case .sign:                         return 16
        case .favoriteCard:                 return 13
        case .bakong, .shareName:           return 11
        default:                            return 15
        }
    }
    
    private static func prefferedFontName(for textStyle: UIFont.TextStyle) -> String {
        switch textStyle {
        case .largeNumbers, .cardNumbers:          return "GTEestiProText-Medium"
        case .smallNumbers, .input, .favoriteCard: return "GTEestiProText-Regular"
        case .welcome:                             return "GTEestiProText-Book"
        case .title1, .title2, .dot, .accent:      return "GTEestiProDisplay-Bold"
        case .button, .sign, .pin:                 return "GTEestiProDisplay-Medium"
        case .bakong:                              return "GothamPro"
        default:                                   return "GTEestiProDisplay-Regular"
        }
    }
    
    public class func styleFont(for style: UIFont.TextStyle) -> UIFont {
        return UIFont(name: prefferedFontName(for: style),
                                    size: prefferedFontSize(for: style))!
    }
    
    static func registerFonts() {
        let items = ["GTEestiProText-Medium" ,"GTEestiProText-Regular", "GTEestiProText-Book", "GTEestiProDisplay-Bold", "GTEestiProDisplay-Medium", "GTEestiProDisplay-Regular"]
        
        for fontName in items {
            try? UIFont.registerFont(with: fontName, withExtension: "otf")
        }
        
        try? UIFont.registerFont(with: "GothamPro", withExtension: "ttf")
    }
    
    private static func registerFont(with name: String, withExtension: String) throws {
        let bundle = Bundle(for: DefaultMapListViewStyle.self)
        guard let fontURL = bundle.url(forResource: name, withExtension: withExtension) else {
            fatalError("Couldn't find font \(name)")
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(name)")
        }

        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            fatalError("Error registering font: maybe it was already registered.")
            print("Error registering font: maybe it was already registered.")
            
        }
    }
    
}


extension UIFont.TextStyle {

    static let largeNumbers = UIFont.TextStyle(rawValue: "kh.org.nbc.large_numbers")
    static let cardNumbers = UIFont.TextStyle(rawValue: "kh.org.nbc.card_numbers")
    static let smallNumbers = UIFont.TextStyle(rawValue: "kh.org.nbc.small_numbers")
    static let button = UIFont.TextStyle(rawValue: "kh.org.nbc.button")
    static let buttonThin = UIFont.TextStyle(rawValue: "kh.org.nbc.button_thin")
    static let sign = UIFont.TextStyle(rawValue: "kh.org.nbc.sign")
    static let pin = UIFont.TextStyle(rawValue: "kh.org.nbc.pin")
    static let dot = UIFont.TextStyle(rawValue: "kh.org.nbc.dot")
    static let input = UIFont.TextStyle(rawValue: "kh.org.nbc.input")
    static let riel = UIFont.TextStyle(rawValue: "kh.org.nbc.riel")
    static let welcome = UIFont.TextStyle(rawValue: "kh.org.nbc.welcome")
    static let accent = UIFont.TextStyle(rawValue: "kh.org.nbc.accent")
    static let favoriteCard = UIFont.TextStyle(rawValue: "kh.org.nbc.favorite_card")
    static let bakong = UIFont.TextStyle(rawValue: "kh.org.nbc.bakong")
    static let shareName = UIFont.TextStyle(rawValue: "kh.org.nbc.share_name")

}
