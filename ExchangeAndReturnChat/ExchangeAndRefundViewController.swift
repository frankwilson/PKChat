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
    lazy private var attachmentsView: ChatAttachmentsView = ChatAttachmentsView()

    private var request: ExchangeAndRefundRequest {
        didSet {
            processRequestStatus(oldValue.status)
        }
    }

    /// Constraint used to move the bottom panel up when displaying keyboard
    private var bottomPanelBottomConstraint: NSLayoutConstraint!

    private var attachments = [MessageFile]() {
        didSet {
            bottomPanel.enableSendButton = attachments.count > 0
        }
    }
    let cancelRequestButton: UIButton = {
        let cancelButton = UIButton(type: .Custom)

        cancelButton.setImage(UIImage(named: "Cancel Chat Icon"), forState: .Normal)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 32, height: 38)
        cancelButton.contentHorizontalAlignment = .Left
        cancelButton.tintColor = UIColor.iphoneDestructiveRedColor()

        return cancelButton
    }()
    let refreshButton: UIButton = {
        let refreshButton = UIButton(type: .Custom)

        refreshButton.setImage(UIImage(named: "Refresh Icon"), forState: .Normal)
        refreshButton.frame = CGRect(x: 32, y: 0, width: 32, height: 38)
        refreshButton.contentHorizontalAlignment = .Right

        return refreshButton
    }()

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
        configureNavigationBar()
        regsterKeyboardNotifications()

        processRequestStatus()
    }

    private func configureChat() {
        // Bottom panel's Confirm button
        chatController.confirmationChangedCallback = { selection in
            if selection == .Confirmed {
                self.bottomPanel.presentConfirmationButton(animated: true, callback: self.fareOfferConfirmed)
            } else {
                self.bottomPanel.hideConfirmationButton(animated: true)
            }
        }
        chatController.retrySendingCallback = {
            print("Retry button pressed")
        }
        chatController.paymentCallback = { ticketId in
            print("Pay button pressed")
        }
    }

    private func configureNavigationBar() {

        let rightButtonsView = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 38))
        rightButtonsView.addSubview(cancelRequestButton)
        rightButtonsView.addSubview(refreshButton)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButtonsView)
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

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bottomPanel]|", options: [], metrics: nil, views: ["bottomPanel": bottomPanel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[chat][bottomPanel]", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: ["chat": chatController.view, "bottomPanel": bottomPanel]))
        bottomPanelBottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: bottomPanel, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraint(bottomPanelBottomConstraint)
    }

    private func processRequestStatus(previousStatus: ExchangeAndRefundRequestStatus? = nil) {
        switch request.status {
        case .Requested:
            if let prevStatus = previousStatus where prevStatus == .Cancelled || prevStatus == .Finished {
                bottomPanel.hideNewRequestButton(animated: true)
            }
        case .Answered:
            break
        case .AwaitingConfirmation:
            bottomPanel.presentConfirmationButton(animated: false, callback: fareOfferConfirmed)
        case .Confirmed:
            if let prevStatus = previousStatus where prevStatus == .AwaitingConfirmation {
                bottomPanel.hideConfirmationButton(animated: true)
            }
        case .Finished:
            fallthrough
        case .Cancelled:
            bottomPanel.presentNewRequestButton(requestType: request.type, animated: true, callback: createNewRequest)
        }
    }

    private func fareOfferConfirmed() {
        // Confirmation callback
    }

    private func createNewRequest() {
        // New request button callback
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

    func hideOrShowAttachmentsView() {
        if let _ = attachmentsView.superview {
            hideAttachmentsView {
                self.attachmentsView.removeFromSuperview()
            }
        } else {
            attachmentsView.frame = CGRect(x: 0, y: CGRectGetMaxY(view.frame), width: view.frame.size.width, height: attachmentsViewHeight)
            view.insertSubview(attachmentsView, belowSubview: bottomPanel)
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[attachments]|", options: [], metrics: nil, views: ["attachments": attachmentsView]))
            view.addConstraint(NSLayoutConstraint(item: attachmentsView, attribute: .Top, relatedBy: .Equal, toItem: bottomPanel, attribute: .Bottom, multiplier: 1.0, constant: 0))
            attachmentsView.constrainHeight(attachmentsViewHeight)
            showAttachmentsView()
        }
    }

    private func showAttachmentsView() {
        // Show attachments
        UIView.animateWithDuration(0.3) {
            self.bottomPanelBottomConstraint.constant = attachmentsViewHeight
            self.view.layoutIfNeeded()
        }
    }
    private func hideAttachmentsView(callback: () -> Void) {
        // Hide attachments
        UIView.animateWithDuration(0.3, animations: {
            self.bottomPanelBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            }, completion: { finished in
                callback()
        })
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

private class ChatAttachmentsView: UIView {

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
        
    }
}
