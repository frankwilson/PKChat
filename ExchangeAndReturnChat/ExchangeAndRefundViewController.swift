//
//  ExchangeAndReturnViewController.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 01/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

class ExchangeAndRefundViewController: UIViewController, ChatMessagePanelDelegate {

    private let chatController: ChatViewController
    lazy private var bottomPanel: ChatSendMessagePanel = {
        let panel = ChatSendMessagePanel(delegate: self)
        return panel
    }()

    private var request: ExchangeAndRefundRequest

    /// Constraint used to move the bottom panel up when displaying keyboard
    private var bottomPanelBottomConstraint: NSLayoutConstraint!

    private var attachments = [MessageFile]() {
        didSet {
            bottomPanel.enableSendButton = attachments.count > 0
        }
    }

    init(request: ExchangeAndRefundRequest) {
        self.request = request
        chatController = ChatViewController(request: request)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureChat()
        configureTitleView()
        configureBottomPanel()
        regsterKeyboardNotifications()
    }

    private func configureChat() {
        // Bottom panel's Confirm button
        chatController.confirmationChangedCallback = { selection in
            self.bottomPanel.presentConfirmationButton(selection == .Confirmed, animated: true)
        }
    }

    private func configureTitleView() {
        let title = request.type == .Exchange ? NSLocalizedString("LocExchangeTickets", comment: "") : NSLocalizedString("LocReturnTickets", comment: "")
        let subtitle = NSString.localizedStringWithFormat(NSLocalizedString("LocOrderN", comment: ""), request.orderNumber) as String
        let titleView = SubtitleTitleView(title: title, subtitle: subtitle)
        // http://stackoverflow.com/questions/15285698/
        titleView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: titleView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize))

        navigationItem.titleView = titleView
    }

    private func configureBottomPanel() {

        switch ChatState(requestStatus: request.status, operatorName: request.operatorName) {
        case .Requested:
            bottomPanel.state = .AwaitingReview
        case .InProcess:
            bottomPanel.state = .InReview
        case .Answered:
            bottomPanel.state = .Normal
        case .AwaitingConfirmation:
            bottomPanel.state = .Normal
        case .Confirmed:
            bottomPanel.state = .Confirmed
        case .Cancelled:
            bottomPanel.state = .Cancelled
        case .Finished:
            bottomPanel.state = .Finished
        case .Other:
            bottomPanel.state = .Disabled
        }

        bottomPanel.enableSendButton = attachments.count > 0

        addChildViewController(chatController)
        view.addSubview(chatController.view)
        view.addSubview(bottomPanel)

        if let message = request.messages.last where message.requestStatus == .AwaitingConfirmation {
            bottomPanel.presentConfirmationButton(true, animated: false)
        }

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bottomPanel]|", options: [], metrics: nil, views: ["bottomPanel": bottomPanel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[chat][bottomPanel]", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: ["chat": chatController.view, "bottomPanel": bottomPanel]))
        bottomPanelBottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: bottomPanel, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraint(bottomPanelBottomConstraint)
    }

    // MARK: Chat Message Panel Delegate
    func sendMessage(message: String) {
        bottomPanel.state = .Sending
        request.messages.append(ChatMessage(id: .None, date: NSDate(), text: message, files: attachments, requestStatus: .Requested, author: .Client))
        chatController.request = request
        dispatch_async(dispatch_get_main_queue()) {
            for stage in 1...20 {
                delay(Double(stage) * 0.2) {
                    let percent = 5.0 * Float(stage) / 100
                    self.bottomPanel.progressBar?.progress = percent
                    print("Set percent to \(percent)")
                    if stage == 20 {
//                        self.bottomPanel.state = .Failed
//                        self.chatController.messageSendingFailed = true
                        self.bottomPanel.state = .Sent
                        delay(2.0) {
                            self.bottomPanel.state = .AwaitingReview
                        }
                    }
                }
            }
        }
    }

    // MARK: Keaboard notification listeners
    private func regsterKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidAppear:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillAppear(n: NSNotification) {
        guard let userInfo = n.userInfo else {
            return
        }
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight = keyboardRect.size.height;
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedLongValue

        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.bottomPanelBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.chatController.scrollToBottom()
        })
    }
    @objc private func keyboardDidAppear(n: NSNotification) {
        chatController.keyboardDidAppear()
    }
    @objc private func keyboardWillDisappear(n: NSNotification) {
        chatController.keyboardWillDisappear()
        guard let userInfo = n.userInfo else {
            return
        }
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedLongValue

        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.bottomPanelBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
