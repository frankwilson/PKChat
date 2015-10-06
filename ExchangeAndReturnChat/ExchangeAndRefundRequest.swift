//
//  ExchangeAndRefundRequest.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 06/10/15.
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

enum ExchangeAndRefundRequestStatus: String {
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
    let status: ExchangeAndRefundRequestStatus
    let reason: ExchangeAndRefundReason

    //    let ticketIds: [String]?
    /// List of File IDs by Chat Message ID
    let files: [Int: String]
    let changeRequests: [ATOrderChangeRequest]
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

    init(data: [String: AnyObject], messages: [ChatMessage], changeRequests: [ATOrderChangeRequest]? = nil) throws {

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

        guard let statusString = stringOrNil(data["Status"]), status = ExchangeAndRefundRequestStatus(rawValue: statusString) else { throw ParseError.Status }
        self.status = status

        guard let reasonString = stringOrNil(data["Reason"]), reason = ExchangeAndRefundReason(rawValue: reasonString) else { throw ParseError.Reason }
        self.reason = reason

        self.messages = messages

        self.files = [Int:String]()
        if let changeRequests = changeRequests {
            self.changeRequests = changeRequests
        } else {
            self.changeRequests = [ATOrderChangeRequest]()
        }
    }
}
