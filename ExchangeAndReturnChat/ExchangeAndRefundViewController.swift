//
//  ExchangeAndReturnViewController.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 01/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

enum ExchangeAndRefundRequestType {
    case Refund
    case Exchange
}

enum ExchangeAndRefundReason {
    case PersonalIssue
    case FlightIssue
    case IllnessOrDeath
    case VisaRefusal
}

struct ExchangeAndRefundRequest {
    let orderNumber: String
    let creationDate: NSDate
    let completionDate: NSDate?
    let requestType: ExchangeAndRefundRequestType
    let reason: ExchangeAndRefundReason

    let messages: [ChatMessage]
}

class ExchangeAndRefundViewController: UIViewController {

    private let chatController = ChatViewController()
    private let bottomPanel = ChatSendMessagePanel()

    private let request: ExchangeAndRefundRequest

    private var bottomPanelBottomConstraint: NSLayoutConstraint!

    init(request: ExchangeAndRefundRequest) {
        self.request = request

        super.init(nibName: nil, bundle: nil)

        chatController.data = request.messages
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTitleView()
        configureBottomPanel()
        regsterKeyboardNotifications()
    }

    private func configureTitleView() {
        let title = request.requestType == .Exchange ? NSLocalizedString("LocExchangeTickets", comment: "") : NSLocalizedString("LocReturnTickets", comment: "")
        let subtitle = NSString.localizedStringWithFormat(NSLocalizedString("LocOrderN", comment: ""), request.orderNumber) as String
        let titleView = SubtitleTitleView(title: title, subtitle: subtitle)
        // http://stackoverflow.com/questions/15285698/
        titleView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: titleView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize))

        navigationItem.titleView = titleView
    }

    private func configureBottomPanel() {

        addChildViewController(chatController)
        view.addSubview(chatController.view)

        view.addSubview(bottomPanel)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bottomPanel]|", options: [], metrics: nil, views: ["bottomPanel": bottomPanel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[chat][bottomPanel]", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: ["chat": chatController.view, "bottomPanel": bottomPanel]))
        bottomPanelBottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: bottomPanel, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraint(bottomPanelBottomConstraint)
    }

    // MARK: Keaboard notification listeners
    private func regsterKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillAppear(n: NSNotification) {
        guard let userInfo = n.userInfo else {
            return
        }
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight = keyboardRect.size.height;
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        self.bottomPanelBottomConstraint.constant = keyboardHeight
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.CurveLinear, .OverrideInheritedDuration], animations: {
            self.bottomPanelBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @objc private func keyboardWillDisappear(n: NSNotification) {
        guard let userInfo = n.userInfo else {
            return
        }
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        self.bottomPanelBottomConstraint.constant = 0
        self.view.setNeedsLayout()
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.CurveLinear, .OverrideInheritedDuration], animations: {
            self.bottomPanelBottomConstraint.constant = 0
            self.view.setNeedsLayout()
        }, completion: nil)

    }
}
