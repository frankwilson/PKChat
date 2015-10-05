//
//  ExchangeAndReturnViewController.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 01/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

let formatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    return formatter
}()

enum ExchangeAndRefundRequestType: String {
    case Refund = "RETURN"
    case Exchange = "CHANGE"
}

enum ExchangeAndRefundReason: String {
    case PersonalIssue = "PERSONAL"
    case FlightIssue = "DELAY"
    case IllnessOrDeath = "ILLNESS"
    case VisaRefusal = "REFUSE"
}

enum ChatRequestStatus: String {
    case Requested = "REQUESTED"
    case Answered = "ANSWERED"
    case AwaitingConfirmation = "AWAITING_CONFIRM"
    case Confirmed = "CONFIRMED"
    case Cancelled = "CANCELED"
    case Finished = "FINISHED"
}

struct ExchangeAndRefundRequest {
    let requestId: String
    let orderNumber: String
    let orderId: String
    let creationDate: NSDate
    let completionDate: NSDate?
    let operatorName: String?
    let type: ExchangeAndRefundRequestType
    let status: ChatRequestStatus
    let reason: ExchangeAndRefundReason

//    let ticketIds: [String]?
//    let fileIds: [String]?
    let messages: [ChatMessage]

    enum ParseError: ErrorType, CustomStringConvertible {
        case RequestId
        case OrderNumber
        case OrderId
        case CreationDate
        case RequestType
        case Status
        case Reason

        var description: String {
            switch self {
            case .RequestId: return "RequestID"
            case .OrderNumber: return "OrderNum"
            case .OrderId: return "OrderId"
            case .CreationDate: return "DateCreated/Date"
            case .RequestType: return "RequestType"
            case .Status: return "Status"
            case .Reason: return "Reason"
            }
        }
    }

    init(data: [String: AnyObject], messages: [ChatMessage]) throws {

        guard let requestId = stringOrNil(data["RequestID"]) else { throw ParseError.RequestId }
        self.requestId = requestId

        guard let orderNumber = stringOrNil(data["OrderNum"]) else { throw ParseError.OrderNumber }
        self.orderNumber = orderNumber

        guard let orderId = stringOrNil(data["OrderId"]) else { throw ParseError.OrderId }
        self.orderId = orderId

        guard let creationDateStr = stringOrNil(data["DateCreated"]?["Date"]), creationDate = formatter.dateFromString(creationDateStr) else { throw ParseError.CreationDate }
        self.creationDate = creationDate

        if let completionDateStr = stringOrNil(data["DateFinished"]?["Date"]), completionDate = formatter.dateFromString(completionDateStr) {
            self.completionDate = completionDate
        } else {
            self.completionDate = .None
        }

        if let operatorName = stringOrNil(data["OperatorOwnerName"]) where operatorName.characters.count > 0 {
            self.operatorName = operatorName
        } else {
            self.operatorName = .None
        }

        guard let typeString = stringOrNil(data["RequestType"]), type = ExchangeAndRefundRequestType(rawValue: typeString) else { throw ParseError.RequestType }
        self.type = type

        guard let statusString = stringOrNil(data["Status"]), status = ChatRequestStatus(rawValue: statusString) else { throw ParseError.Status }
        self.status = status

        guard let reasonString = stringOrNil(data["Reason"]), reason = ExchangeAndRefundReason(rawValue: reasonString) else { throw ParseError.Reason }
        self.reason = reason

        self.messages = messages
    }
}

class ExchangeAndRefundViewController: UIViewController {

    private let chatController: ChatViewController
    private let bottomPanel = ChatSendMessagePanel()

    private let request: ExchangeAndRefundRequest

    private var bottomPanelBottomConstraint: NSLayoutConstraint!

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

        configureTitleView()
        configureBottomPanel()
        regsterKeyboardNotifications()
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
