//
//  ChatConfirmationBlockCell.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 06/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

private let mainBlockWidth: CGFloat = 300

private let buttonBlockHeight: CGFloat = 36

private let topCellMargin: CGFloat = 18.0
private let bottomCellMargin: CGFloat = 20.0
private let sideCellMargin: CGFloat = 20.0

enum ChatConfirmationCellMode {
    case AwaitingConfirmation
    case Confirmed
    case Rejected
    case WaitingForPayment(priceText: String)
    case PaymentCaptured
    case PaymentComplete
    case InProcess
}

class ChatConfirmationBlockCell: UICollectionViewCell {

    private static let titleFont = UIFont.iphoneRegularFont(20.0)
    private static let passengerFont = UIFont.iphoneRegularFont(14.0)
    private static let messageFont = UIFont.iphoneRegularFont(14.0)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = titleFont
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center

        return label
    }()
    private let passengerLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = passengerFont
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping

        return label
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = messageFont
        label.textColor = UIColor.iphoneMainGrayColor()
        label.textAlignment = .Center
        label.numberOfLines = 0

        return label
    }()
    private let mainBlock: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "Confirmation Cell Main Block"
        view.backgroundColor = UIColor.iphoneTroutColor().colorWithAlphaComponent(0.5)
        view.layer.cornerRadius = 6.0
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: mainBlockWidth))

        return view
    }()
    private let buttonBlock = ChatConfirmationButtonView()

    var mode: ChatConfirmationCellMode = .AwaitingConfirmation

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func size(text text: String, passengerName: String?) -> CGSize {
        var height = topCellMargin + bottomCellMargin

        // title height
        let titleText = NSLocalizedString("LocExchangeTickets", comment: "")
        height += NSString(string: titleText).awad_boundsWithFont(titleFont, maxWidth: mainBlockWidth - sideCellMargin * 2).height

        if let passenger = passengerName {
            height += 20
            height += NSString(string: passenger.uppercaseString).awad_boundsWithFont(passengerFont, maxWidth: mainBlockWidth - sideCellMargin * 2).height
        }

        // message height
        height += 10
        height += NSString(string: text).awad_boundsWithFont(messageFont, maxWidth: mainBlockWidth - sideCellMargin * 2).height

        // button height
        height += 15
        height += buttonBlockHeight

        return CGSize(width: mainBlockWidth, height: height)
    }

    private func initializeView() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainBlock)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainBlock]|", options: [], metrics: nil, views: ["mainBlock": mainBlock]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainBlock]|", options: [], metrics: nil, views: ["mainBlock": mainBlock]))
    }

    func configureView(chatType chatType: ExchangeAndRefundRequestType, mode: ChatConfirmationCellMode, message: String, passengerName: String? = nil) {
        self.mode = mode

        titleLabel.text = NSLocalizedString(chatType == .Exchange ? "LocExchangeTickets" : "LocReturnTickets", comment: "")
        messageLabel.text = message
        buttonBlock.configureView(mode)

        mainBlock.addSubview(titleLabel)
        mainBlock.addSubview(messageLabel)
        mainBlock.addSubview(buttonBlock)

        let labels = ["title": titleLabel, "passenger": passengerLabel, "message": messageLabel, "button": buttonBlock]
        let metrics = ["top": topCellMargin, "bottom": bottomCellMargin, "buttonHeight": buttonBlockHeight]
        let format: String
        let passengerNameText: String?
        switch mode {
        case .WaitingForPayment(_), .PaymentCaptured, .PaymentComplete:
            passengerNameText = passengerName?.uppercaseString ?? "Unknown"
        default:
            passengerNameText = nil
        }

        if let passengerName = passengerNameText {
            passengerLabel.text = passengerName
            mainBlock.addSubview(passengerLabel)
            format = "V:|-top-[title]-15-[passenger]-15-[message]-15-[button(buttonHeight)]-bottom-|"
        } else {
            format = "V:|-top-[title]-10-[message]-15-[button(buttonHeight)]-bottom-|"
        }
        mainBlock.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: [.AlignAllLeading, .AlignAllTrailing], metrics: metrics, views: labels))
        mainBlock.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: mainBlock, attribute: .Leading, multiplier: 1.0, constant: sideCellMargin))
        mainBlock.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: mainBlock, attribute: .Trailing, multiplier: 1.0, constant: -sideCellMargin))

        layoutIfNeeded()
    }

}

private class ChatConfirmationButtonView: UIView {

    var currentButtonView: UIView?

    init() {
        super.init(frame: CGRectZero)

        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureView(mode: ChatConfirmationCellMode) {
        let view: UIView

        switch mode {
        case .AwaitingConfirmation:
            // Segmented control – Accept or Continue Chat
            view = AcceptConditionsView()
        case .Confirmed:
            // Conditions Accepted block
            view = ConditionsAcceptedView()
        case .Rejected:
            // Conditions Rejected block
            view = ConditionsRejectedView()
        case .WaitingForPayment(let priceText):
            // Pay button
            view = PaymentView(title: priceText)
        case .PaymentCaptured(), .PaymentComplete:
            // Dashed Payed button
            view = PaymentView()
        case .InProcess:
            // TODO: Check! Is InProcess a possible status for a Payment Block?
            view = PaymentView()
        }
        currentButtonView?.removeFromSuperview()
        currentButtonView = view
        addSubview(view)
        addConstraint(NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[buttonView]|", options: [], metrics: nil, views: ["buttonView": view]))
    }

}

private class AcceptConditionsView: UIView {

    init() {
        super.init(frame: CGRectZero)

        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false

        let segmentedControl = UISegmentedControl(items: [
            NSLocalizedString("LocAccept", comment: ""),
            NSLocalizedString("LocContinueConversation", comment: "")
        ])
        segmentedControl.tintColor = UIColor.iphoneBlueColor()
        segmentedControl.addRoundCorners(radius: 16.0, borderColor: UIColor.iphoneBlueColor())
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.iphoneRegularFont(13.0), NSForegroundColorAttributeName: UIColor.iphoneBlueColor()], forState: .Normal)
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.iphoneRegularFont(13.0), NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)

        addSubview(segmentedControl)
        addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[control]|", options: [], metrics: nil, views: ["control": segmentedControl]))
    }
}

private class ConditionsAcceptedView: UIView {

    init() {
        super.init(frame: CGRectZero)

        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 150.0))

        addRoundCorners(radius: 5.0, borderColor: UIColor.whiteColor())

        let imageView = UIImageView(image: UIImage(named: "Chat Confirmation Checkmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.whiteColor()
        imageView.sizeToFit()
        addSubview(imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 12.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 0.84
        let attrText = NSAttributedString(string: NSLocalizedString("LocExchangeConfirmed", comment: ""), attributes: [NSParagraphStyleAttributeName: paragraph])

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.iphoneDefaultFont(14.0)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 2
        label.attributedText = attrText

        addSubview(label)
        addConstraint(NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: imageView, attribute: .Trailing, multiplier: 1.0, constant: 8.0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
}

private class ConditionsRejectedView: UIView {

    init() {
        super.init(frame: CGRectZero)

        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 150.0))

        addRoundCorners(radius: 5.0, borderColor: UIColor.iphoneMainGrayColor())

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.iphoneRegularFont(16.0)
        label.textColor = UIColor.iphoneMainGrayColor()
        label.text = NSLocalizedString("LocRejected", comment: "")

        addSubview(label)
        addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
}

private class PaymentView: UIView {

    private let callback: (() -> Void)?

    init(title: String? = nil, callback: (() -> Void)? = nil) {

        self.callback = callback
        super.init(frame: CGRectZero)
        initializeView(title: title, enabled: title != nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView(title title: String?, enabled: Bool) {
        translatesAutoresizingMaskIntoConstraints = false

        let imageButton = UIButton(type: .Custom)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.setBackgroundImage(UIImage(named: "Buy Button"), forState: .Normal)
        imageButton.setBackgroundImage(UIImage(named: "Bought Button"), forState: .Disabled)
        imageButton.setTitle(title, forState: .Normal)
        imageButton.setTitle(NSLocalizedString("LocPaid", comment:""), forState: .Disabled)
        imageButton.setTitleColor(UIColor.iphoneMainGrayColor(), forState: .Disabled)
        imageButton.titleLabel?.font = UIFont.iphoneRegularFont(16.0)
        imageButton.enabled = enabled

        imageButton.addTarget(self, action: "payButtonPressed", forControlEvents: .TouchUpInside)

        addSubview(imageButton)
        addConstraint(NSLayoutConstraint(item: imageButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }

    @objc func payButtonPressed() {
        print("Button pressed!")

        if let callback = self.callback {
            callback()
        }
    }
}
