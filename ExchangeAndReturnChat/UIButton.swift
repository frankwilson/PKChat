//
//  UIButton.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 09/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

private let roundCornersButtonMargin: CGFloat = 17

extension UIButton {

    class func withRoundCorners(title title: String, width: CGFloat? = nil) -> Self {

        let attrTitleNormal = NSAttributedString(string: title, attributes: [
            NSFontAttributeName: UIFont.iphoneDefaultFont(14.0),
            NSForegroundColorAttributeName: UIColor.iphoneBlueColor()
        ])
        let attrTitleDisabled = NSAttributedString(string: title, attributes: [
            NSFontAttributeName: UIFont.iphoneDefaultFont(14.0),
            NSForegroundColorAttributeName: UIColor.iphoneMainGrayColor()
        ])

        let button = self.init(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attrTitleNormal, forState: .Normal)
        button.setAttributedTitle(attrTitleDisabled, forState: .Disabled)
        button.addRoundCorners(radius: 14.0, borderColor: UIColor.iphoneBlueColor())
        button.constrainHeight(30.0)
        if let buttonWidth = width {
            button.constrainWidth(buttonWidth)
        } else {
            let textSize = NSString(string: title).awad_boundsWithFont(UIFont.iphoneDefaultFont(14.0))
            button.constrainWidth(textSize.width + roundCornersButtonMargin * 2)
        }

        return button
    }

    class func buyButton(title title: String?) -> Self {

        let attrTitleNormal: NSAttributedString?
        if let title = title {
            attrTitleNormal = NSAttributedString(string: title, attributes: [
                NSFontAttributeName: UIFont.iphoneRegularFont(16.0),
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ])
        } else {
            attrTitleNormal = nil
        }
        let attrTitleDisabled = NSAttributedString(string: NSLocalizedString("LocPaid", comment:""), attributes: [
            NSFontAttributeName: UIFont.iphoneRegularFont(16.0),
            NSForegroundColorAttributeName: UIColor.iphoneMainGrayColor()
        ])

        let imageButton = self.init(type: .Custom)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.setBackgroundImage(UIImage(named: "Buy Button"), forState: .Normal)
        imageButton.setBackgroundImage(UIImage(named: "Bought Button"), forState: .Disabled)
        imageButton.setAttributedTitle(attrTitleNormal, forState: .Normal)
        imageButton.setAttributedTitle(attrTitleDisabled, forState: .Disabled)

        return imageButton
    }
}
