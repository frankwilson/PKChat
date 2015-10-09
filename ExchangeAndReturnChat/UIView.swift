//
//  UIView.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 07/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

enum HorizontalPosition {

    case Top
    case Bottom

}

extension UIView {

    /**
     * Adds round corners to the view
     *
     * - parameter raduis: Round corners radius
     * - parameter borderColor: Border color (optional)
     * - parameter borderWidth: Border width, default - 1. Set to 0 to not show border.
     * - parameter masksToBounds: Sets whether view should be clipped by round corners, default - true.
     */
    func addRoundCorners(radius radius: CGFloat, borderColor: UIColor? = nil, borderWidth: CGFloat = 1.0, masksToBounds: Bool = true) {
        layer.borderColor = borderColor?.CGColor
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.masksToBounds = masksToBounds
    }

    func addHorizontalSeparatorLine(position: HorizontalPosition) {
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor.iphoneTroutColor()
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLineView)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[line]|", options: [], metrics: nil, views: ["line": topLineView]))
        topLineView.constrainHeight(1.0)
        if position == .Top {
            addConstraint(NSLayoutConstraint(item: topLineView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        } else if position == .Bottom {
            addConstraint(NSLayoutConstraint(item: topLineView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant:-1.0))
        }
    }

    // MARK: - Short versions of constraints
    func constrainWidth(width: CGFloat) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: width)
        addConstraint(c)
        return c
    }
    func constrainHeight(height: CGFloat) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
        addConstraint(c)
        return c
    }
    func constrainWidth(width: CGFloat, height: CGFloat) {
        constrainWidth(width)
        constrainHeight(height)
    }
}
