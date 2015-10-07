//
//  UIView.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 07/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

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
}
