//
//  ChatConfirmationBlockCell.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 06/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

private let mainBlockWidth: CGFloat = 300
let maxTextWidth: CGFloat = mainBlockWidth - sideCellMargin * 2

private let buttonBlockHeight: CGFloat = 36

private let topCellMargin: CGFloat = 18.0
private let bottomCellMargin: CGFloat = 20.0
private let sideCellMargin: CGFloat = 8.0

enum ExchangeConfirmationOption: Int {
    case Confirmed
    case ContinueChat
}

enum ChatConfirmationCellMode {
    case AwaitingConfirmation(optionCallback: (selection: ExchangeConfirmationOption) -> Void, selection: ExchangeConfirmationOption)
    case Confirmed
    case Rejected
    case WaitingForPayment(changeRequestId: String, priceText: String, payButtonCallback: (changeRequestId: String) -> Void)
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
    lazy private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = messageFont
        label.textColor = UIColor.iphoneMainGrayColor()
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.text = NSLocalizedString("LocChangeTermsDisagreeDescription", comment: "")

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

    var mode: ChatConfirmationCellMode = .InProcess

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.removeFromSuperview()
        messageLabel.removeFromSuperview()
        buttonBlock.removeFromSuperview()
        passengerLabel.removeFromSuperview()
        descriptionLabel.removeFromSuperview()
    }

    class func size(mode mode: ChatConfirmationCellMode, text: String, passengerName: String?, selection: ExchangeConfirmationOption? = .Confirmed) -> CGSize {

        var height = topCellMargin + bottomCellMargin

        // title height
        let titleText = NSLocalizedString("LocExchangeTickets", comment: "")
        height += NSString(string: titleText).awad_boundsWithFont(titleFont, maxWidth: maxTextWidth).height

        if let passenger = passengerName {
            height += 20
            height += NSString(string: passenger.uppercaseString).awad_boundsWithFont(passengerFont, maxWidth: maxTextWidth).height
        }

        // message height
        height += 10
        height += NSString(string: text).awad_boundsWithFont(messageFont, maxWidth: maxTextWidth).height

        if case .AwaitingConfirmation(_) = mode, let selection = selection, case .ContinueChat = selection {
            height += additionalHeightForContinueChatMessage()
        }

        // button height
        height += 15
        height += buttonBlockHeight

        return CGSize(width: mainBlockWidth, height: height)
    }

    class func additionalHeightForContinueChatMessage() -> CGFloat {
        var height: CGFloat = 15
        let descriptionText = NSLocalizedString("LocChangeTermsDisagreeDescription", comment: "")
        height += NSString(string: descriptionText).awad_boundsWithFont(messageFont, maxWidth: maxTextWidth).height
        return height
    }

    private func initializeView() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainBlock)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainBlock]|", options: [], metrics: nil, views: ["mainBlock": mainBlock]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainBlock]|", options: [], metrics: nil, views: ["mainBlock": mainBlock]))
    }

    func configureView(chatType chatType: ExchangeAndRefundRequestType, mode: ChatConfirmationCellMode, message: String, passengerName: String? = nil, selection: ExchangeConfirmationOption? = .Confirmed) {
        self.mode = mode

        titleLabel.text = NSLocalizedString(chatType == .Exchange ? "LocExchangeTickets" : "LocReturnTickets", comment: "")
        messageLabel.text = message
        var updatedMode = mode
        // Consider it a hack that is enhancing a callback with additional functionality
        if case .AwaitingConfirmation(let callback, let currentSelection) = mode {
            updatedMode = .AwaitingConfirmation(optionCallback: { selection in
                // Show or hide Continue Chat message
                UIView.animateWithDuration(0.3, animations: {
                    self.descriptionLabel.alpha = selection == .Confirmed ? 0.0 : 1.0
                    if case .ContinueChat = selection {
                        self.addConfirmationDescriptionLabel()
                    }
                    self.superview!.layoutIfNeeded()
                }, completion: { completed in
                    if case .Confirmed = selection {
                        self.descriptionLabel.removeFromSuperview()
                    }
                })
                callback(selection: selection)
            }, selection: currentSelection)
        }
        buttonBlock.configureView(updatedMode)

        mainBlock.addSubview(titleLabel)
        mainBlock.addSubview(messageLabel)
        mainBlock.addSubview(buttonBlock)

        let labels = ["title": titleLabel, "passenger": passengerLabel, "message": messageLabel, "button": buttonBlock, "description": descriptionLabel]
        let metrics = ["top": topCellMargin, "bottom": bottomCellMargin, "buttonHeight": buttonBlockHeight]
        let format: String
        let passengerNameText: String?
        switch mode {
        case .WaitingForPayment(_), .PaymentCaptured, .PaymentComplete:
            passengerNameText = passengerName?.uppercaseString ?? "Unknown"
        default:
            passengerNameText = nil
        }
        switch mode {
        case .AwaitingConfirmation(_):
            if let selection = selection, case .ContinueChat = selection {
                self.addConfirmationDescriptionLabel()
            }
            fallthrough
        case .Confirmed, .Rejected, .InProcess:
            format = "V:|-top-[title]-15-[message]-15-[button(buttonHeight)]->=bottom-|"
        case .WaitingForPayment(_, _, _), .PaymentCaptured, .PaymentComplete:
            passengerLabel.text = passengerNameText
            mainBlock.addSubview(passengerLabel)
            format = "V:|-top-[title]-15-[passenger]-15-[message]-15-[button(buttonHeight)]-bottom-|"
        }
        mainBlock.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: [.AlignAllLeading, .AlignAllTrailing], metrics: metrics, views: labels))
        mainBlock.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: mainBlock, attribute: .Leading, multiplier: 1.0, constant: sideCellMargin))
        mainBlock.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: mainBlock, attribute: .Trailing, multiplier: 1.0, constant: -sideCellMargin))

        layoutIfNeeded()
    }

    private func addConfirmationDescriptionLabel() {
        mainBlock.addSubview(descriptionLabel)
        mainBlock.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button]-15-[description]-bottom-|", options: [], metrics: ["bottom": bottomCellMargin], views: ["button": buttonBlock, "description": descriptionLabel]))
        mainBlock.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: descriptionLabel, attribute: .Leading, multiplier: 1.0, constant: 0))
        mainBlock.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: descriptionLabel, attribute: .Trailing, multiplier: 1.0, constant: 0))
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
        case let .AwaitingConfirmation(optionCallback, selection):
            // Segmented control – Accept or Continue Chat
            view = AcceptConditionsView(optionCallback: optionCallback, selection: selection)
        case .Confirmed:
            // Conditions Accepted block
            view = ConditionsAcceptedView()
        case .Rejected:
            // Conditions Rejected block
            view = ConditionsRejectedView()
        case let .WaitingForPayment(changeRequestId, priceText, callback):
            // Pay button
            view = PaymentView(title: priceText) {
                callback(changeRequestId: changeRequestId)
            }
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

    private let optionCallback: (ExchangeConfirmationOption -> Void)?

    init(optionCallback: (ExchangeConfirmationOption -> Void)?, selection: ExchangeConfirmationOption = .Confirmed) {
        self.optionCallback = optionCallback
        super.init(frame: CGRectZero)

        initializeView(selection)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView(selection: ExchangeConfirmationOption = .Confirmed) {
        translatesAutoresizingMaskIntoConstraints = false

        let segmentedControl = UISegmentedControl(items: [
            NSLocalizedString("LocAccept", comment: ""),
            NSLocalizedString("LocContinueConversation", comment: "")
        ])
        segmentedControl.tintColor = UIColor.iphoneBlueColor()
        segmentedControl.addRoundCorners(radius: 16.0, borderColor: UIColor.iphoneBlueColor())
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = selection.rawValue
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.iphoneRegularFont(13.0), NSForegroundColorAttributeName: UIColor.iphoneBlueColor()], forState: .Normal)
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.iphoneRegularFont(13.0), NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
        segmentedControl.addTarget(self, action: "optionChanged:", forControlEvents: .ValueChanged)

        addSubview(segmentedControl)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[control]|", options: [], metrics: nil, views: ["control": segmentedControl]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[control]|", options: [], metrics: nil, views: ["control": segmentedControl]))
    }

    @objc private func optionChanged(control: UISegmentedControl) {
        if let callback = self.optionCallback {
            callback(ExchangeConfirmationOption(rawValue: control.selectedSegmentIndex)!)
        }
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

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "payButtonPressed"))

        let imageButton = UIButton.buyButton(title: title)
        imageButton.enabled = enabled

        imageButton.addTarget(self, action: "payButtonPressed", forControlEvents: .TouchUpInside)

        addSubview(imageButton)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]|", options: [], metrics: nil, views: ["button": imageButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: [], metrics: nil, views: ["button": imageButton]))
    }

    @objc func payButtonPressed() {
        if let callback = self.callback {
            callback()
        }
    }
}
