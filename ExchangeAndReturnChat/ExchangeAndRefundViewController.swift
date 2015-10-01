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

        configureBottomPanel()
    }

    private func configureBottomPanel() {

        addChildViewController(chatController)
        view.addSubview(chatController.view)

        view.addSubview(bottomPanel)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[bottomPanel]|", options: [], metrics: nil, views: ["bottomPanel": bottomPanel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[chat][bottomPanel]|", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: ["chat": chatController.view, "bottomPanel": bottomPanel]))
    }

}
