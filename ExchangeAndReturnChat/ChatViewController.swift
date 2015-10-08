//
//  ExchangeAndReturnChatViewController.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 29/09/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

private let chatCellIdentifier = "ExchangeAndReturnChatBubble"
private let confirmationCellIdentifier = "ExchangeAndReturnConfirmationBlock"
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

    init(requestStatus: ExchangeAndRefundRequestStatus, operatorName: String?) {
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
    let requestStatus: ExchangeAndRefundRequestStatus
    let authorType: MessageAuthorType

    init(id: Int, date: NSDate, text: String? = nil, files: [MessageFile]? = nil, requestStatus: ExchangeAndRefundRequestStatus, author: MessageAuthorType) {
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
            c.registerClass(ChatConfirmationBlockCell.self, forCellWithReuseIdentifier: confirmationCellIdentifier)
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
        if message.requestStatus == .Confirmed {
            count += self.request.changeRequests.count
        }
        return count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize = CGSize(width: bubbleCellWidth(), height: 40.0)

        // Calculate a cell height
        let message = request.messages[indexPath.section]
        if indexPath.row == message.files.count, let text = message.text {
            if message.requestStatus == .AwaitingConfirmation {
                cellSize = ChatConfirmationBlockCell.size(text: text, passengerName: nil)
            } else {
                cellSize.height = ChatCollectionViewCell.size(text: text, maxWidth: maxBubbleWidth(), documentStyle: false).height
            }
        } else if indexPath.row > message.files.count && request.changeRequests.count > 0 {
            let requestIndex = indexPath.row - (message.text != nil ? 1 : 0) - message.files.count
            let currentChangeRequest = request.changeRequests[requestIndex]
            cellSize = ChatConfirmationBlockCell.size(text: currentChangeRequest.localizedStatus(), passengerName: currentChangeRequest.passengerName)
        } else if case .OtherFile(let fileName) = message.files[indexPath.row] {
            cellSize.height = ChatCollectionViewCell.size(text: fileName, maxWidth: maxBubbleWidth(), documentStyle: true).height
        } else if case .Image(let image) = message.files[indexPath.row] {
            cellSize.height = (cellSize.width * 0.5) / image.size.width * image.size.height
        }

        return cellSize
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let message = request.messages[indexPath.section]

        let cell: UICollectionViewCell

        if indexPath.row == message.files.count && message.requestStatus == .AwaitingConfirmation {
            let aCell = collectionView.dequeueReusableCellWithReuseIdentifier(confirmationCellIdentifier, forIndexPath: indexPath) as! ChatConfirmationBlockCell
            let nextMessage: ChatMessage? = request.messages.count > indexPath.section + 1 ? request.messages[indexPath.section + 1] : nil
            configureConfirmationCell(aCell, message: message, nextMessage: nextMessage)
            cell = aCell
        } else if indexPath.row > message.files.count && request.changeRequests.count > 0 {
            let aCell = collectionView.dequeueReusableCellWithReuseIdentifier(confirmationCellIdentifier, forIndexPath: indexPath) as! ChatConfirmationBlockCell
            let requestIndex = indexPath.row - (message.text != nil ? 1 : 0) - message.files.count
            configurePaymentCell(aCell, changeRequest: request.changeRequests[requestIndex])
            cell = aCell
        } else {
            let aCell = collectionView.dequeueReusableCellWithReuseIdentifier(chatCellIdentifier, forIndexPath: indexPath) as! ChatCollectionViewCell
            configureBubbleCell(aCell, indexPath: indexPath, message: message)
            cell = aCell
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

    private func configureBubbleCell(cell: ChatCollectionViewCell, indexPath: NSIndexPath, message: ChatMessage) {

        cell.maxBubbleWidth = maxBubbleWidth()
        cell.backgroundColor = self.collectionView?.backgroundColor

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
    }

    /**
     * Configures Confirmation Block cell
     *
     * - parameter cell: Cell to configure
     * - parameter message: Current message
     * - parameter nextMessage: Next message that defines a current block status – Accepted, Rejected, Not Confirmed (if nil)
     */
    private func configureConfirmationCell(cell: ChatConfirmationBlockCell, message: ChatMessage, nextMessage: ChatMessage?) {

        let cellMode: ChatConfirmationCellMode

        switch message.requestStatus {
        case .AwaitingConfirmation:
            if let nextMessage = nextMessage {
                if nextMessage.requestStatus == .Confirmed {
                    cellMode = .Confirmed
                } else {
                    cellMode = .Rejected
                }
            } else {
                cellMode = .AwaitingConfirmation
            }
        case .Confirmed:
            cellMode = .Confirmed
        default:
            cellMode = .AwaitingConfirmation
        }

        cell.configureView(chatType: request.type, mode: cellMode, message: message.text!)
    }

    private func configurePaymentCell(cell: ChatConfirmationBlockCell, changeRequest: ATOrderChangeRequest) {

        let cellMode: ChatConfirmationCellMode

        if changeRequest.status == .WaitingForPayment {
            let priceFormatter = NSNumberFormatter()
            priceFormatter.numberStyle = .CurrencyStyle
            // FIXME: Get price from a ChangeRequest
            let value = NSNumber(double: 342.05)
            let priceText = priceFormatter.stringFromNumber(value)!
            cellMode = ChatConfirmationCellMode.WaitingForPayment(priceText: priceText)
        } else if changeRequest.status == .PaymentCaptured {
            cellMode = .PaymentComplete
        } else if changeRequest.status == .PaymentComplete {
            cellMode = .PaymentComplete
        } else {
            cellMode = .InProcess
        }

        let passengerName: String? = changeRequest.passengerName

        cell.configureView(chatType: request.type, mode: cellMode, message: changeRequest.localizedStatus(), passengerName: passengerName)
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
