//
//  ChatSendMessagePanel.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 01/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

private let textViewVerticalMargin: CGFloat = 8.0

private let minTextViewHeight: CGFloat = 28.0
private let maxTextViewHeight: CGFloat = 152.0 // 7 lines

enum ChatSendMessagePanelState {
    case Normal
    case Sending
    case Sent
    case Failed
    case Disabled
    case AwaitingReview
    case InReview
    case Confirmed
    case Finished
    case Cancelled
}

protocol ChatMessagePanelDelegate: class {
    func sendMessage(message: String)
}

class ChatSendMessagePanel: UIView {

    var state = ChatSendMessagePanelState.Normal {
        didSet {
            updateWithNewState()
        }
    }
    var enableSendButton = false {
        didSet {
            composeView.enableSendButton = enableSendButton
        }
    }
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.iphoneDefaultFont(17.0)
        label.textColor = UIColor.iphoneMainGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private(set) var progressBar: UIProgressView?
    private let composeView: ComposeView
    lazy private var confirmView: ConfirmButtonView = ConfirmButtonView()

    init(delegate: ChatMessagePanelDelegate) {
        self.composeView = ComposeView(delegate: delegate)

        super.init(frame: CGRectZero)

        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func presentConfirmationButton(show: Bool, animated: Bool) {
        if show {
            addSubview(confirmView)
            let topConstraint = NSLayoutConstraint(item: confirmView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: animated ? self.bounds.size.height : 0.0)
            addConstraint(topConstraint)
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[confirmView]|", options: [], metrics: nil, views: ["confirmView": confirmView]))
            self.superview!.layoutIfNeeded()
            self.composeView.textView.resignFirstResponder()
            if animated {
                UIView.animateWithDuration(0.3) {
                    topConstraint.constant = 0.0
                    self.composeView.textViewHeightConstraint.constant = minTextViewHeight
                    self.superview!.layoutIfNeeded()
                }
            }
        } else if animated {
            for constraint in self.constraints where constraint.firstAttribute == .Top && constraint.firstItem === confirmView {
                self.removeConstraint(constraint)
                break
            }
            let topConstraint = NSLayoutConstraint(item: confirmView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -self.bounds.size.height)
            addConstraint(topConstraint)
            UIView.animateWithDuration(0.3, animations: {
                topConstraint.constant = 0.0
                self.composeView.resizeTextView(self.composeView.textView)
                self.superview!.layoutIfNeeded()
            }, completion: { completed in
                self.confirmView.removeFromSuperview()
            })
        } else {
            confirmView.removeFromSuperview()
        }
    }

    private func initializeView() {
        backgroundColor = UIColor.iphoneMainNavbarColor()
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(composeView)
        addSubview(statusLabel)

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[composeView]|", options: [], metrics: nil, views: ["composeView": composeView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[composeView]|", options: [], metrics: nil, views: ["composeView": composeView]))

        addConstraint(NSLayoutConstraint(item: statusLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: statusLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))

        addHorizontalSeparatorLine(.Top)
    }

    private func updateWithNewState() {
        statusLabel.hidden = false
        composeView.hidden = true
        progressBar?.hidden = true
        progressBar = nil

        let message: String?

        switch state {
        case .Normal:
            statusLabel.hidden = true
            composeView.hidden = false
            message = nil
        case .Sending:
            message = NSLocalizedString("LocExchangeSendingMsg", comment: "")
            addProgressBar()
        case .Sent:
            message = NSLocalizedString("LocExchangeMsgSent", comment: "")
        case .Failed:
            message = NSLocalizedString("LocExchangeTryLater", comment: "")
        case .Disabled:
            statusLabel.hidden = true
            composeView.hidden = false
            message = nil
        case .AwaitingReview:
            message = NSLocalizedString("LocExchangeRequested", comment: "Ожидает рассмотрения оператором")
        case .InReview:
            message = NSLocalizedString("LocExchangeInProcess", comment: "Рассматривается оператором")
        case .Confirmed:
            message = NSLocalizedString("LocExchangeConfirmed", comment: "Условия подтверждены")
        case .Finished:
            message = NSLocalizedString("LocRequestFinished", comment: "Запрос выполнен")
        case .Cancelled:
            message = NSLocalizedString("LocRequestCancelled", comment: "Запрос отменен")
        }

        if let message = message {
            let animation = CATransition()
            animation.duration = 0.3
            animation.type = kCATransitionFade
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

            statusLabel.layer.addAnimation(animation, forKey: "changeTextTransition")
            statusLabel.text = message
        }
    }

    private func addProgressBar() {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.0
        addSubview(progressView)
        progressBar = progressView

        addConstraint(NSLayoutConstraint(item: progressView, attribute: .Width, relatedBy: .Equal, toItem: statusLabel, attribute: .Width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: progressView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: progressView, attribute: .Top, relatedBy: .Equal, toItem: statusLabel, attribute: .Bottom, multiplier: 1.0, constant: 2.0))
    }

}

private class ComposeView: UIView, UITextViewDelegate {

    private let textView: UITextView = {
        let textView = UITextView()
        textView.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.iphoneDefaultFont(16.0)
        textView.layer.cornerRadius = 6.0
        textView.autocorrectionType = .No
        textView.spellCheckingType = .No
        textView.keyboardAppearance = .Dark
        textView.textContainerInset = UIEdgeInsets(top: 4.0, left: 0.0, bottom: 4.0, right: 0.0)
        //textView.placeholder = NSLocalizedString("LocExchangeMessage", comment: "Placeholder for a exchange & refund chat text field")

        return textView
    }()
    private let attachButton: UIButton = {
        let button = UIButton(type: .System)
        button.setImage(UIImage(named: "Chat Camera Icon"), forState: .Normal)
        button.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.iphoneBlueColor()

        return button
    }()
    private let sendButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setTitle("Send", forState: .Normal)
        button.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.iphoneDefaultFont(14.0)
        // TODO: This could be applied application-wide
        button.setTitleColor(UIColor.iphoneBlueColor(), forState: .Normal)
        button.setTitleColor(UIColor.iphoneMainGrayColor(), forState: .Disabled)
        button.enabled = false

        return button
    }()
    private let placeholderView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.iphoneDefaultFont(16.0)
        label.textColor = UIColor.iphoneMainGrayColor()
        label.text = NSLocalizedString("LocExchangeMessage", comment: "")
        label.userInteractionEnabled = false

        return label
    }()
    private var enableSendButton = false {
        didSet {
            enableSendButtonIfNeeded()
        }
    }
    private let delegate: ChatMessagePanelDelegate
    private var textViewHeightConstraint: NSLayoutConstraint!

    init(delegate: ChatMessagePanelDelegate) {
        self.delegate = delegate
        super.init(frame: CGRectZero)

        sendButton.addTarget(self, action: "sendButtonPressed", forControlEvents: .TouchUpInside)
        attachButton.addTarget(self, action: "attachButtonPressed", forControlEvents: .TouchUpInside)

        textView.delegate = self

        initializeView()
        enableTextViewContentSizeObserver(true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        enableTextViewContentSizeObserver(false)
    }

    private func initializeView() {
        backgroundColor = UIColor.iphoneMainNavbarColor()
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(attachButton)
        addSubview(textView)
        addSubview(sendButton)
        addSubview(placeholderView)

        let views = ["attachButton": attachButton, "textView": textView, "sendButton": sendButton]

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-5-[attachButton(44)]-5-[textView]-8-[sendButton]-8-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[textView]-margin-|", options: [], metrics: ["margin": textViewVerticalMargin], views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|->=0-[attachButton(44)]-<=5-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|->=0-[sendButton(44)]-<=5-|", options: [], metrics: nil, views: views))

        addConstraint(NSLayoutConstraint(item: placeholderView, attribute: .Leading, relatedBy: .Equal, toItem: textView, attribute: .Leading, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint(item: placeholderView, attribute: .Trailing, relatedBy: .Equal, toItem: textView, attribute: .Trailing, multiplier: 1.0, constant: -4))
        addConstraint(NSLayoutConstraint(item: placeholderView, attribute: .Top, relatedBy: .Equal, toItem: textView, attribute: .Top, multiplier: 1.0, constant: 3))
        addConstraint(NSLayoutConstraint(item: placeholderView, attribute: .Bottom, relatedBy: .Equal, toItem: textView, attribute: .Bottom, multiplier: 1.0, constant: -4))

        textViewHeightConstraint = textView.constrainHeight(minTextViewHeight)
    }

    @objc private func attachButtonPressed() {
        NSLog("Attach button pressed")
    }

    @objc private func sendButtonPressed() {
        let message = textView.text.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        textView.resignFirstResponder()
        textView.text = nil
        delegate.sendMessage(message)
    }

    private func enableSendButtonIfNeeded() {
        sendButton.enabled = enableSendButton || textView.text.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet()).characters.count > 0
    }

    // MARK: Text view delegate
    private func enableTextViewContentSizeObserver(enable: Bool) {
        if enable {
            textView.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        } else {
            textView.removeObserver(self, forKeyPath: "contentSize")
        }
    }

    private func resizeTextView(textView: UITextView) {
        let contentSize = textView.contentSize

        if contentSize.height < minTextViewHeight || textView.text.characters.count == 0 {
            self.textViewHeightConstraint.constant = minTextViewHeight
        } else if contentSize.height <= maxTextViewHeight {
            self.textViewHeightConstraint.constant = contentSize.height
        }
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let textView = object as? UITextView else {
            return
        }
        resizeTextView(textView)
        textView.layoutIfNeeded()
    }

    @objc func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView.text.characters.count == 0 {
                // Pointless to add new line as first character
                return false;
            } else if range.location > 0 && textView.text[textView.text.startIndex.advancedBy(range.location - 1)] == "\n" {
                // Character before
                return false;
            } else if textView.text.characters.count > range.location && textView.text[textView.text.startIndex.advancedBy(range.location)] == "\n" {
                // Character after
                return false;
            }
        }
        return true;
    }
    @objc func textViewDidChange(textView: UITextView) {
        placeholderView.hidden = (textView.text.characters.count > 0)
        enableSendButtonIfNeeded()
    }
}

private class ConfirmButtonView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        backgroundColor = UIColor.iphoneMainNavbarColor()
        translatesAutoresizingMaskIntoConstraints = false

        constrainHeight(44.0)

        let button = UIButton.withRoundCorners(title: NSLocalizedString("LocConfirmChoice", comment: ""), width: 200.0)

        addSubview(button)
        addConstraint(NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))

        addHorizontalSeparatorLine(.Top)
    }
}
