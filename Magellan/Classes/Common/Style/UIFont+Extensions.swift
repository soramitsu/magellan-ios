//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

extension UIFont {
    
    static func registerFonts() {
        let items = ["GTEestiProText-Medium" ,"GTEestiProText-Regular", "GTEestiProText-Book", "GTEestiProDisplay-Bold", "GTEestiProDisplay-Medium", "GTEestiProDisplay-Regular"]
        
        for fontName in items {
            try? UIFont.registerFont(with: fontName, withExtension: "otf")
        }
        
        try? UIFont.registerFont(with: "GothamPro", withExtension: "ttf")
    }
    
    private static func registerFont(with name: String, withExtension: String) throws {
        let bundle = Bundle(for: DefaultMagellanStyle.self)
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
