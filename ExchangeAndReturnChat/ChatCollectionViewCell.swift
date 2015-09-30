//
//  ChatCollectionViewCell.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 29/09/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

enum ChatElementPosition {
    case Left
    case Center
    case Right
}

private let clientBubbleColor = UIColor(red:0.91, green:0.922, blue:0.941, alpha:1)
private let operatorBubbleColor = UIColor(red:0.929, green:0.376, blue:0.533, alpha:1)

private let clientTextColor = UIColor.blackColor()
private let operatorTextColor = UIColor.whiteColor()

private let clientBubbleTextInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 15.0)
private let operatorBubbleTextInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 10.0)

class ChatCollectionViewCell: UICollectionViewCell {

    var maxBubbleWidth: CGFloat = 0.0

    private var position = ChatElementPosition.Left
    private var text: String?
    private var imageUrl: NSURL?

    private var bubbleLeagingConstraint: NSLayoutConstraint!
    private var bubbleWidthConstraint: NSLayoutConstraint!
    private var bubbleLabelLeadingConstraint: NSLayoutConstraint!
    private var bubbleLabelTrailingConstraint: NSLayoutConstraint!

    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        label.numberOfLines = 0

        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bubbleView)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bubbleView]|", options: [.AlignAllCenterY], metrics: nil, views: ["bubbleView": bubbleView]))
        bubbleLeagingConstraint = NSLayoutConstraint(item: bubbleView, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .Leading, multiplier: 1, constant: 0)
        contentView.addConstraint(bubbleLeagingConstraint)
        bubbleWidthConstraint = NSLayoutConstraint(item: bubbleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
        contentView.addConstraint(bubbleWidthConstraint)

        bubbleView.addSubview(imageView)
        bubbleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[imageView]|", options: [.AlignAllCenterX], metrics: nil, views: ["imageView": imageView]))
        bubbleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: [.AlignAllCenterY], metrics: nil, views: ["imageView": imageView]))

        bubbleView.addSubview(textLabel)
        bubbleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[label]-5-|", options: [.AlignAllCenterY], metrics: nil, views: ["label": textLabel]))
        bubbleLabelLeadingConstraint = NSLayoutConstraint(item: textLabel, attribute: .Leading, relatedBy: .Equal, toItem: bubbleView, attribute: .Leading, multiplier: 1, constant: 10)
        bubbleView.addConstraint(bubbleLabelLeadingConstraint)
        bubbleLabelTrailingConstraint = NSLayoutConstraint(item: bubbleView, attribute: .Trailing, relatedBy: .Equal, toItem: textLabel, attribute: .Trailing, multiplier: 1, constant: 10)
        bubbleView.addConstraint(bubbleLabelTrailingConstraint)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func sizeWithText(text: String, maxWidth: CGFloat) -> CGSize {
        // Short name
        let insets = clientBubbleTextInsets
        let maxTextWidth = maxWidth - insets.left - insets.right

        let textSize = NSString(string: text).awad_boundsWithFont(UIFont(name: "HelveticaNeue-Light", size: 16.0), maxWidth: maxTextWidth)

        return CGSize(width: ceil(textSize.width + insets.left + insets.right), height: ceil(textSize.height + insets.top + insets.bottom))
    }

    override func prepareForReuse() {
        textLabel.text = nil
        textLabel.backgroundColor = nil
        imageView.image = nil
    }

    func configure(text: String, position: ChatElementPosition) {
        self.text = text
        self.imageUrl = nil
        self.position = position

        configureView()
    }

    func configure(imageUrl: NSURL, position: ChatElementPosition) {
        self.text = nil
        self.imageUrl = imageUrl
        self.position = position

        configureView()
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        // Dirty hack! have to update mask layer size somehow
        bubbleView.layer.mask?.frame = bubbleView.layer.bounds
    }

    private func configureView() {

        let bubbleWidth: CGFloat
        if let text = self.text {
            textLabel.text = text
            bubbleWidth = ChatCollectionViewCell.sizeWithText(text, maxWidth: maxBubbleWidth).width
            bubbleView.backgroundColor = position == .Left ? operatorBubbleColor : clientBubbleColor
            textLabel.backgroundColor = bubbleView.backgroundColor
            textLabel.textColor = position == .Left ? operatorTextColor : clientTextColor
        } else if let imageUrl = self.imageUrl {
            // TODO: Replace with async image loading
            imageView.image = UIImage(data: NSData(contentsOfURL: imageUrl)!)
            bubbleWidth = ceil(bounds.size.width / 2)
        } else {
            return
        }

        let offset = floor(bounds.size.width - bubbleWidth)

        bubbleWidthConstraint.constant = bubbleWidth
        bubbleLeagingConstraint.constant = position == .Left ? 0 : offset
        bubbleLabelLeadingConstraint.constant = position == .Left ? 15.0 : 10.0
        bubbleLabelTrailingConstraint.constant = position == .Right ? 15.0 : 10.0

        let imageName = position == .Left ? "ChatBubble – Operator" : "ChatBubble – Client"

        let bubbleInsets = UIEdgeInsets(top: 14.0, left: position == .Left ? 19.0 : 15.0, bottom: 15.0, right: position == .Right ? 19.0 : 15.0)
        let image = UIImage(named: imageName)!.resizableImageWithCapInsets(bubbleInsets)

        let maskLayer = CALayer()
        maskLayer.contents = image.CGImage
        maskLayer.contentsScale = UIScreen.mainScreen().scale
        maskLayer.contentsCenter = CGRect(x: bubbleInsets.left / image.size.width, y: bubbleInsets.top / image.size.height, width: 1.0 / image.size.width, height: 1.0 / image.size.height)

        bubbleView.layer.mask = maskLayer
        bubbleView.layer.masksToBounds = true

        self.updateConstraintsIfNeeded()
    }
}
