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

private let documentBubbleTextLeftInset: CGFloat = 28
private let failedBubbleRightInset: CGFloat = 32

class ChatCollectionViewCell: UICollectionViewCell {

    var maxBubbleWidth: CGFloat = 0.0
    /// Present a cell as Failed to send
    var failed = false {
        didSet {
            if oldValue != failed {
                markAsFailed()
            }
        }
    }

    private var position = ChatElementPosition.Left
    private var text: String?
    private var image: UIImage?

    private var bubbleLeagingConstraint: NSLayoutConstraint!
    private var bubbleWidthConstraint: NSLayoutConstraint!
    private var bubbleLabelLeadingConstraint: NSLayoutConstraint!
    private var bubbleLabelTrailingConstraint: NSLayoutConstraint!

    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        label.font = UIFont.iphoneDefaultFont(16.0)
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping

        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    private var documentImageView: UIImageView?
    private var warningButtonImageView: UIButton?
    private let bubbleView = BubbleView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bubbleView)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bubbleView]|", options: [], metrics: nil, views: ["bubbleView": bubbleView]))
        bubbleLeagingConstraint = NSLayoutConstraint(item: bubbleView, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .Leading, multiplier: 1, constant: 0)
        contentView.addConstraint(bubbleLeagingConstraint)
        bubbleWidthConstraint = NSLayoutConstraint(item: bubbleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
        contentView.addConstraint(bubbleWidthConstraint)

        bubbleView.addSubview(imageView)
        bubbleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: [], metrics: nil, views: ["imageView": imageView]))
        bubbleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: [], metrics: nil, views: ["imageView": imageView]))

        bubbleView.addSubview(textLabel)
        bubbleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[label]-5-|", options: [], metrics: nil, views: ["label": textLabel]))
        bubbleLabelLeadingConstraint = NSLayoutConstraint(item: textLabel, attribute: .Leading, relatedBy: .Equal, toItem: bubbleView, attribute: .Leading, multiplier: 1, constant: 10)
        bubbleView.addConstraint(bubbleLabelLeadingConstraint)
        bubbleLabelTrailingConstraint = NSLayoutConstraint(item: bubbleView, attribute: .Trailing, relatedBy: .Equal, toItem: textLabel, attribute: .Trailing, multiplier: 1, constant: 10)
        bubbleView.addConstraint(bubbleLabelTrailingConstraint)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func size(text text: String, maxWidth: CGFloat, documentStyle: Bool) -> CGSize {
        // Short name
        let insets = clientBubbleTextInsets
        let maxTextWidth = maxWidth - insets.left - insets.right - (documentStyle ? documentBubbleTextLeftInset : 0.0)

        let textSize = NSString(string: text).awad_boundsWithFont(UIFont.iphoneDefaultFont(16.0), maxWidth: maxTextWidth, useWordWrap: !documentStyle)

        var horizontalInsets = insets.left + insets.right
        if documentStyle {
            horizontalInsets += documentBubbleTextLeftInset
        }

        var verticalInsets = insets.top + insets.bottom
        if documentStyle {
            verticalInsets *= 2
        }
        return CGSize(width: ceil(textSize.width + horizontalInsets), height: ceil(textSize.height + verticalInsets))
    }

    override func prepareForReuse() {
        textLabel.text = nil
        textLabel.backgroundColor = nil
        imageView.image = nil
    }

    func configure(text text: String, position: ChatElementPosition, documentStyle: Bool) {
        self.text = text
        self.image = nil
        self.position = position

        configureView(documentStyle)
    }

    func configure(image image: UIImage, position: ChatElementPosition) {
        self.text = nil
        self.image = image
        self.position = position

        configureView()
    }

    private func configureView(documentStyle: Bool = false) {

        let bubbleWidth: CGFloat
        if let text = self.text {
            textLabel.text = text
            bubbleWidth = ChatCollectionViewCell.size(text: text, maxWidth: maxBubbleWidth, documentStyle: documentStyle).width
            bubbleView.backgroundColor = position == .Left ? operatorBubbleColor : clientBubbleColor
            textLabel.backgroundColor = bubbleView.backgroundColor
            textLabel.textColor = position == .Left ? operatorTextColor : clientTextColor
            if documentStyle {
                textLabel.lineBreakMode = .ByTruncatingTail
                textLabel.textColor = textLabel.textColor.colorWithAlphaComponent(0.6)
            } else {
                textLabel.lineBreakMode = .ByWordWrapping
            }
            textLabel.numberOfLines = documentStyle ? 1 : 0
        } else if let image = self.image {
            imageView.image = image
            bubbleWidth = ceil(bounds.size.width / 2)
        } else {
            return
        }
        displayDocumentImage(documentStyle)

        let offset = floor(bounds.size.width - bubbleWidth - (failed ? failedBubbleRightInset : 0.0))

        bubbleWidthConstraint.constant = bubbleWidth
        bubbleLeagingConstraint.constant = position == .Left ? 0 : offset
        bubbleLabelLeadingConstraint.constant = (position == .Left ? 15.0 : 10.0) + (documentStyle ? documentBubbleTextLeftInset : 0.0)
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
        bubbleView.layer.mask?.frame = bubbleView.layer.bounds

        self.updateConstraintsIfNeeded()
    }

    private func displayDocumentImage(display: Bool) {

        documentImageView?.removeFromSuperview()
        if display {
            let imageView: UIImageView
            if let image = documentImageView {
                imageView = image
            } else  {
                imageView = UIImageView(image: UIImage(named: "Chat Document Icon"))
                imageView.tintColor = textLabel.textColor
                imageView.translatesAutoresizingMaskIntoConstraints = false
                documentImageView = imageView
            }
            let leftOffset = (position == .Left ? 15.0 : 10.0)
            bubbleView.addSubview(imageView)
            bubbleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[image]", options: [], metrics: ["left": leftOffset], views: ["image": imageView]))
            bubbleView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: bubbleView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        }
    }

    private func markAsFailed() {
        if failed {
            let warningButton = UIButton(type: .Custom)
            warningButton.setBackgroundImage(UIImage(named: "Warning Sign"), forState: .Normal)
            warningButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(warningButton)
            contentView.addConstraint(NSLayoutConstraint(item: warningButton, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: warningButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
            warningButtonImageView = warningButton
            UIView.animateWithDuration(0.1) {
                self.bubbleLeagingConstraint.constant -= failedBubbleRightInset
                self.layoutIfNeeded()
            }
        } else {
            warningButtonImageView?.removeFromSuperview()
            warningButtonImageView = nil
            UIView.animateWithDuration(0.1) {
                self.bubbleLeagingConstraint.constant += failedBubbleRightInset
                self.layoutIfNeeded()
            }
        }
    }

}

private class BubbleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.mask?.frame = layer.bounds
    }

}
