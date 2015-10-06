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

enum ChatConfirmationCellMode {
    case AwaitingConfirmation
    case Confirmed
    case Rejected
    case WaitingForPayment
    case PaimentCaptured
    case PaymentComplete
}

class ChatConfirmationBlockCell: UICollectionViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.iphoneRegularFont(20.0)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center

        return label
    }()
    private let passengerLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.iphoneRegularFont(14.0)
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
        label.font = UIFont.iphoneRegularFont(14.0)
        label.textColor = UIColor.iphoneMainGrayColor()
        label.textAlignment = .Center

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
        return CGSize(width: mainBlockWidth, height: 160.0)
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
        let metrics = ["top": topCellMargin, "bottom": bottomCellMargin]
        let format: String

        if mode == .WaitingForPayment {
            passengerLabel.text = passengerName ?? "Unknown"
            mainBlock.addSubview(passengerLabel)
            format = "V:|-top-[title]-15-[passenger]-15-[message]-15-[button]-bottom-|"
        } else {
            format = "V:|-top-[title]-10-[message]-15-[button]-bottom-|"
        }
        mainBlock.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: [.AlignAllLeading, .AlignAllTrailing], metrics: metrics, views: labels))
        mainBlock.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: mainBlock, attribute: .Leading, multiplier: 1.0, constant: 20.0))
        mainBlock.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: mainBlock, attribute: .Trailing, multiplier: 1.0, constant: -20.0))

        layoutIfNeeded()
    }

}

private class ChatConfirmationButtonView: UIView {

    init() {
        super.init(frame: CGRectZero)

        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonBlockHeight))

    }

    private func configureView(mode: ChatConfirmationCellMode) {
        let view: UIView
        // Segmented control – Accept or Continue chat
        // Conditions Accepted block
        // Conditions Rejected block
        // Pay button
        // Dashed Payed button
        switch mode {
        case .AwaitingConfirmation:
            view = AcceptConditionsView()
        case .Confirmed:
            view = ConditionsAcceptedView()
        default:
            view = AcceptConditionsView()
        }
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
        segmentedControl.layer.borderColor = UIColor.iphoneBlueColor().CGColor
        segmentedControl.layer.cornerRadius = 16.0
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.masksToBounds = true
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1
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

        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0

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
        label.numberOfLines = 2
        label.font = UIFont.iphoneDefaultFont(14.0)
        label.textColor = UIColor.whiteColor()
        label.attributedText = attrText

        addSubview(label)
        addConstraint(NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: imageView, attribute: .Trailing, multiplier: 1.0, constant: 8.0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }

}
