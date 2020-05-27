//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

extension UIFont {
    
    static func registerFonts() {
        let items = ["Sora-Bold" ,"Sora-ExtraBold", "Sora-ExtraLight", "Sora-Light", "Sora-Regular", "Sora-SemiBold", "Sora-Thin"]
        
        for fontName in items {
            try? UIFont.registerFont(with: fontName, withExtension: "otf")
        }
    }
    
    private static func registerFont(with name: String, withExtension: String) throws {
        let bundle = Bundle(for: DemoViewController.self)
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
        let _ = CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
}
