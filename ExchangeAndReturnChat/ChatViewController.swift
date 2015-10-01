//
//  ExchangeAndReturnChatViewController.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 29/09/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

private let chatCellIdentifier = "ExchangeAndReturnChatBubble"
private let chatHeaderIdentifier = "ExchangeAndReturnChatDateAndTime"

enum ChatElementType {
    case ClientBubble(date: NSDate, text: String?, url: NSURL?)
    case OperatorBubble(date: NSDate, text: String?, url: NSURL?)
}

enum ChatRequestStatus: String {
    case Requested = "REQUESTED"
    case Answered = "ANSWERED"
    case AwaitingConfirmation = "AWAITING_CONFIRM"
    case Confirmed = "CONFIRMED"
    case Cancelled = "CANCELED"
    case Finished = "FINISHED"
//    case Other
}

enum MessageAuthorType {
    case Client
    case Operator
}

struct ChatMessage {
    let date: NSDate
    let text: String?
    let imageUrl: NSURL?
    let requestStatus: ChatRequestStatus
    let authorType: MessageAuthorType

    init(date: NSDate, text: String? = nil, imageUrl: NSURL? = nil, requestStatus: ChatRequestStatus, author: MessageAuthorType) {
        self.date = date
        self.text = text
        self.imageUrl = imageUrl
        self.requestStatus = requestStatus
        self.authorType = author
    }
}

class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var data = [ChatMessage]()

    private let layout = UICollectionViewFlowLayout()
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter
    }()

    init() {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        edgesForExtendedLayout = UIRectEdge.None
        view.translatesAutoresizingMaskIntoConstraints = false

        collectionView?.backgroundColor = UIColor(red:0.122, green:0.129, blue:0.137, alpha:1) /* #1f2123 */

        collectionView?.registerClass(ChatCollectionViewCell.self, forCellWithReuseIdentifier: chatCellIdentifier)
        collectionView?.registerClass(ChatDateAndTimeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: chatHeaderIdentifier)

        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: 100, height: 24)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return data.count
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If section has image and a text
        guard data.count > section else {
            return 0
        }
        let message = data[section]
        if message.text != nil && message.imageUrl != nil {
            return 2
        } else {
            return 1
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellHeight: CGFloat = 40.0
        let cellWidth = bubbleCellWidth()

        // Calculate a cell height
        let message = data[indexPath.section]
        if indexPath.row == 0 && message.imageUrl != nil {
            cellHeight = ceil(cellWidth * 0.5 * 0.66) // 2/3 of a half of the width. Bubble width should be a half of the cell width
        } else if let text = message.text {
            cellHeight = ChatCollectionViewCell.sizeWithText(text, maxWidth: maxBubbleWidth()).height
        }

        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(chatCellIdentifier, forIndexPath: indexPath) as! ChatCollectionViewCell
        cell.maxBubbleWidth = maxBubbleWidth()
        cell.backgroundColor = self.collectionView?.backgroundColor

        let message = data[indexPath.section]
        let position: ChatElementPosition
        switch message.authorType {
        case .Client:
            position = .Right // Client is always right
        case .Operator:
            position = .Left
        }

        if indexPath.row == 0 {
            if let imageUrl = message.imageUrl {
                cell.configure(imageUrl, position: position)
            } else if let text =  message.text {
                cell.configure(text, position: position)
            }
        } else if let text =  message.text {
            // Duplicated call! Rid of it if possible
            cell.configure(text, position: position)
        }

        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: chatHeaderIdentifier, forIndexPath: indexPath) as! ChatDateAndTimeSectionHeaderView
            view.backgroundColor = self.collectionView?.backgroundColor
            let message = data[indexPath.section]
            view.label.text = dateFormatter.stringFromDate(message.date)

            return view
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
    }

    func maxBubbleWidth() -> CGFloat {
        return bubbleCellWidth() * 0.7
    }
    func bubbleCellWidth() -> CGFloat {
        return ceil((self.view.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right) * 0.95)
    }

}

private class ChatDateAndTimeSectionHeaderView: UICollectionReusableView {

    private var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        label.textColor = UIColor(red:0.506, green:0.537, blue:0.596, alpha:1) /* #818998 awadColorIphoneMainGray */
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        self.addSubview(label)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[label]|", options: [.AlignAllCenterX], metrics: nil, views: ["label": label]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [.AlignAllCenterY], metrics: nil, views: ["label": label]))
    }

}
