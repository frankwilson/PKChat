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
private let chatFooterIdentifier = "ExchangeAndReturnChatFinishStatus"

enum ChatState {
    case Requested
    case InProcess
    case Answered
    case AwaitingConfirmation
    case Confirmed
    case Cancelled
    case Finished
    case Other

    init(requestStatus: ChatRequestStatus, operatorName: String?) {
        switch requestStatus {
        case .Requested: self = (operatorName == nil ? .Requested : .InProcess)
        case .Answered: self = .Answered
        case .AwaitingConfirmation: self = .AwaitingConfirmation
        case .Confirmed: self = .Confirmed
        case .Cancelled: self = .Cancelled
        case .Finished: self = .Finished
        }
    }

    var description: String {
        let statusCode: String
        switch self {
        case .Requested: statusCode = "LocExchangeRequested"
        case .InProcess: statusCode = "LocExchangeInProcess"
        case .Answered: statusCode = "LocExchangeAnswered"
        case .AwaitingConfirmation: statusCode = "LocExchangeAwaitingConfirm"
        case .Confirmed: statusCode = "LocExchangeConfirmed"
        case .Cancelled: statusCode = "LocRequestCancelled"
        case .Finished: statusCode = "LocRequestFinished"
        case .Other: statusCode = "LocOther"
        }

        return NSLocalizedString(statusCode, comment: "Exchange & Refund request status description")
    }
}

enum MessageAuthorType {
    case Client
    case Operator
}

enum MessageFile {
    case Image(image: UIImage)
    case OtherFile(fileName: String)
}

struct ChatMessage {
    let id: Int
    let date: NSDate
    let text: String?
    let files: [MessageFile]
    let requestStatus: ChatRequestStatus
    let authorType: MessageAuthorType

    init(id: Int, date: NSDate, text: String? = nil, files: [MessageFile]? = nil, requestStatus: ChatRequestStatus, author: MessageAuthorType) {
        self.id = id
        self.date = date
        self.text = text
        self.files = files ?? [MessageFile]()
        self.requestStatus = requestStatus
        self.authorType = author
    }
}

class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var request: ExchangeAndRefundRequest

//    private var state = ChatState.Requested

    private let layout = UICollectionViewFlowLayout()

    init(request: ExchangeAndRefundRequest) {
        self.request = request
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        edgesForExtendedLayout = UIRectEdge.None
        view.translatesAutoresizingMaskIntoConstraints = false

        if let c = collectionView {
            c.backgroundColor = UIColor.iphoneDarkBackgroundColor()

            c.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

            c.registerClass(ChatCollectionViewCell.self, forCellWithReuseIdentifier: chatCellIdentifier)
            c.registerClass(ChatDateAndTimeReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: chatHeaderIdentifier)
            c.registerClass(ChatFinishedReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: chatFooterIdentifier)
        }

        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.headerReferenceSize = CGSize(width: 100, height: 24)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Scroll to the very bottom
        let sectionIndex = numberOfSectionsInCollectionView(collectionView!) - 1
        let lastIndexPath = NSIndexPath(forRow: collectionView(collectionView!, numberOfItemsInSection: sectionIndex) - 1, inSection: sectionIndex)

        collectionView!.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: true)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return request.messages.count
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard request.messages.count > section else {
            return 0
        }
        let message = request.messages[section]

        var count = message.files.count
        if message.text != nil {
            count++
        }
        return count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellHeight: CGFloat = 40.0
        let cellWidth = bubbleCellWidth()

        // Calculate a cell height
        let message = request.messages[indexPath.section]
        if indexPath.row == message.files.count, let text = message.text {
            cellHeight = ChatCollectionViewCell.sizeWithText(text, maxWidth: maxBubbleWidth(), documentStyle: false).height
        } else if case .OtherFile(let fileName) = message.files[indexPath.row] {
            cellHeight = ChatCollectionViewCell.sizeWithText(fileName, maxWidth: maxBubbleWidth(), documentStyle: true).height
        } else if case .Image(let image) = message.files[indexPath.row] {
            cellHeight = (cellWidth * 0.5) / image.size.width * image.size.height
        }

        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(chatCellIdentifier, forIndexPath: indexPath) as! ChatCollectionViewCell
        cell.maxBubbleWidth = maxBubbleWidth()
        cell.backgroundColor = self.collectionView?.backgroundColor

        let message = request.messages[indexPath.section]
        let position: ChatElementPosition
        switch message.authorType {
        case .Client:
            position = .Right // Client is always right
        case .Operator:
            position = .Left
        }

        if indexPath.row == message.files.count, let text = message.text {
            cell.configure(text: text, position: position, documentStyle: false)
        } else if case .OtherFile(let fileName) = message.files[indexPath.row] {
            cell.configure(text: fileName, position: position, documentStyle: true)
        } else if case .Image(let image) = message.files[indexPath.row] {
            cell.configure(image: image, position: position)
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let message = request.messages[section]

        if message.requestStatus == .Cancelled || message.requestStatus == .Finished {
            return CGSize(width: 200, height: 24)
        } else {
            return CGSizeZero
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let message = request.messages[indexPath.section]

            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: chatHeaderIdentifier, forIndexPath: indexPath) as! ChatDateAndTimeReusableView
            view.backgroundColor = self.collectionView?.backgroundColor
            view.configure(date: message.date)

            return view
        } else if kind == UICollectionElementKindSectionFooter {
            let message = request.messages[indexPath.section]

            if message.requestStatus == .Cancelled || message.requestStatus == .Finished {
                let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: chatFooterIdentifier, forIndexPath: indexPath) as! ChatFinishedReusableView
                view.backgroundColor = self.collectionView?.backgroundColor
                view.configure(statusDescription: ChatState(requestStatus: message.requestStatus, operatorName: request.operatorName).description, date: message.date, showUnderline: false)

                return view
            }
        }
        return UICollectionReusableView()
    }

    func maxBubbleWidth() -> CGFloat {
        return bubbleCellWidth() * 0.7
    }
    func bubbleCellWidth() -> CGFloat {
        return ceil((self.view.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right) * 0.95)
    }

}

private class ChatDateAndTimeReusableView: UICollectionReusableView {

    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter
    }()

    private var label: UILabel = {
        let label = UILabel()

        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        label.textColor = UIColor.iphoneMainGrayColor()
        label.font = UIFont.iphoneDefaultFont(16.0)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(date date: NSDate) {
        label.text = "\(ChatDateAndTimeReusableView.dateFormatter.stringFromDate(date))"
    }

    private func initializeView() {

        addSubview(label)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [.AlignAllCenterX], metrics: nil, views: ["label": label]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [.AlignAllCenterY], metrics: nil, views: ["label": label]))
    }

}

private class ChatFinishedReusableView: UICollectionReusableView {

    private static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        return dateFormatter
    }()

    private var label: UILabel = {
        let label = UILabel()

        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        label.textColor = UIColor.iphoneMainGrayColor()
        label.font = UIFont.iphoneRegularFont(14.0)

        return label
    }()
    lazy private var separator: UIView = {
        let separator = UIView()

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.iphoneTroutColor()

        return separator
    }()
    private var verticalConstraints = [NSLayoutConstraint]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        separator.removeFromSuperview()
    }

    func configure(statusDescription statusText: String, date: NSDate, showUnderline: Bool) {
        label.text = "\(ChatFinishedReusableView.dateFormatter.stringFromDate(date)) \(statusText)"

        if showUnderline {
            addSubview(separator)
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[separator]|", options: [], metrics: nil, views: ["separator": separator]))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]-3-[separator(1)]|", options: [], metrics: nil, views: ["label": label, "separator": separator]))
        } else {
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [], metrics: nil, views: ["label": label]))
        }
    }

    private func initializeView() {

        addSubview(label)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: nil, views: ["label": label]))
    }

}
