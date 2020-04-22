//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import class UIKit.UIColor
import struct CoreGraphics.CGFloat


extension UIColor {

    fileprivate static func hex(red: Int, green: Int, blue: Int) -> UIColor {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        return .init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    fileprivate static func hex(_ hex: Int) -> UIColor {
        return .hex(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    enum Style {
        
        struct Text {
            
            static let input: UIColor = .black
            
            static let body: UIColor = .hex(0x6D6D72)
            
            static let title: UIColor = .black
            
            static let caption: UIColor = .hex(0x6A6A6A)
            
            static let button: UIColor = .hex(0xA7A7A7)
            
            static let description: UIColor = .hex(0xA5A5A5)
            
            static let header: UIColor  = .hex(0x9B9B9B)
            
            static let announcement: UIColor = .hex(0x797979)
            
            static let register: UIColor = .hex(0x4A4A4A)
            
            static let detail: UIColor = .hex(0x2E2E2E)
            
            static let mapOpened: UIColor = .hex(0x00A167)
            
            static let mapClosed: UIColor = .hex(0xD0021B)
            
            static let mapDetail: UIColor = .hex(0x027AD0)
            
        }
        
        static let tint: UIColor = .hex(0x7D0022)
    
        static let background: UIColor = .hex(0xF5F5F5)
        
        static let verify: UIColor = .hex(0x75A062)

        static let usd: UIColor = .hex(0xE57901)
        
        static let riel: UIColor = .hex(0xA10000)
        
        static let withdraw: UIColor = .hex(0xE54C58)
        
        static let receive: UIColor = .hex(0x73B24F)

        static let upload: UIColor = .hex(0x797173)
        
        static let pinBox: UIColor = .hex(0xC2C1C3)
        
        static let error: UIColor = .hex(0xFF3B30)
        
        static let highlight: UIColor = .hex(0xEBB603)
        
        static let transactionStatusBackground: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        
        static let separator: UIColor = .hex(0x979797)
        
        static let tableSeparator: UIColor = UIColor.hex(0xE1E1E1).withAlphaComponent(0.63)
        
        static let pillStroke: UIColor = .hex(0xE1E1E1)
        
        static let next: UIColor = .hex(0xd0021b)
        
        static let ok: UIColor = .hex(0x009532)
        
        static let scanProblem: UIColor = .hex(0xffc800)
        
        static let pan: UIColor = .hex(0xdddddd)

    }
    
}
