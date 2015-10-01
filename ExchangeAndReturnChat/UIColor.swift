//
//  UIColor.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 01/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import Foundation

extension UIColor {

    convenience public init(colorCode: Int) {
        self.init(
            red:CGFloat((colorCode & 0xFF0000) >> 16) / 255,
            green:CGFloat((colorCode & 0xFF00) >> 8) / 255,
            blue:CGFloat(colorCode & 0xFF) / 255,
            alpha:1
        )
    }

    @inline(__always) class func iphoneMainNavbarColor() -> UIColor {
        return UIColor(colorCode: 0x1F2123)
    }
    @inline(__always) class func iphoneDarkBackgroundColor() -> UIColor {
        return UIColor(colorCode: 0x20252A)
    }
    @inline(__always) class func iphoneTroutColor() -> UIColor {
        return UIColor(colorCode: 0x4A515F)
    }
    @inline(__always) class func iphoneBlueColor() -> UIColor {
        return UIColor(colorCode: 0x39AEE0)
    }
    @inline(__always) class func iphoneMainGrayColor() -> UIColor {
        return UIColor(colorCode: 0x818998)
    }

}
