//
//  ChatSendMessagePanel.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 01/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

class ChatSendMessagePanel: UIView {

    private let textView = UITextView()
    private let sendButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: ChatSendMessagePanel.self, action: "sendButtonPressed")

        return button
    }()
    private var panelHeightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        backgroundColor = UIColor.magentaColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        panelHeightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 44.0)
        self.addConstraint(panelHeightConstraint)
    }

    private func sendButtonPressed() {
        NSLog("Send button pressed")
    }

}
