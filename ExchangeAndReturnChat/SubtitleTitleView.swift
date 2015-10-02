//
//  2LineTitleView.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 01/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

class SubtitleTitleView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.iphoneDefaultFont(16.0)
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()

        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.iphoneRegularFont(12.0)
        label.textAlignment = .Center
        label.textColor = UIColor.iphoneMainGrayColor()

        return label
    }()

    init(title: String, subtitle: String) {
        super.init(frame: CGRectZero)

        titleLabel.text = title
        subtitleLabel.text = subtitle

        addSubview(titleLabel)
        addSubview(subtitleLabel)

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title][subtitle]|", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: ["title": titleLabel, "subtitle": subtitleLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=0)-[title]-(>=0)-|", options: [], metrics: nil, views: ["title": titleLabel]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
}
