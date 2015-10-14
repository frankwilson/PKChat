//
//  ViewController.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 29/09/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var sideViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        UINavigationBar.appearance().barTintColor = UIColor.iphoneMainNavbarColor()
    }

    @IBAction func didTapButton(button: UIButton) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        let image01 = UIImage(named: "hotel_pool.jpg")!
        let image02 = UIImage(named: "portrait_btbob.jpg")!

        let messages = [
            ChatMessage(id: 808366, date: formatter.dateFromString("2015-08-14T13:09:17.39Z")!, text: "Здравствуйте!\nПодскажите, пожалуйста, а у вас есть ольховые плинтуса?", requestStatus: .Requested, author: .Client),
            ChatMessage(id: 808367, date: formatter.dateFromString("2015-08-14T13:10:57.67Z")!, text: "Нет, у нас только дубовые!", files: [.OtherFile(fileName: "Frak you, Spielberg!.docx")], requestStatus: .Answered, author: .Operator),
            ChatMessage(id: 808368, date: formatter.dateFromString("2015-08-14T13:11:43.03Z")!, text: "Хм, но как же так... А у меня есть какой-нибудь выбор?", files: [.Image(image: image01), .OtherFile(fileName: "How To Sheet In The Woods.pdf")], requestStatus: .Requested, author: .Client),
            ChatMessage(id: 808369, date: formatter.dateFromString("2015-08-14T13:13:42.32Z")!, text: "Конечно, у вас есть выбор! Взять дубовые, или пойти и выкоречевать ольху. Ведь все дубы пошли на плинтуса, а ольха нет!", requestStatus: .AwaitingConfirmation, author: .Operator),
//            ChatMessage(id: 808420, date: formatter.dateFromString("2015-08-14T13:18:33.39Z")!, text: "I'll take it from here.", files: [.Image(image: image02)], requestStatus: .Confirmed, author: .Client),
            ChatMessage(id: 808420, date: formatter.dateFromString("2015-08-14T13:18:33.39Z")!, text: "Ну и ладно. Оставайтесь при своих.", files: [.Image(image: image02)], requestStatus: .Requested, author: .Client),
            ChatMessage(id: 808367, date: formatter.dateFromString("2015-08-14T13:10:57.67Z")!, text: "Непременно!", requestStatus: .Answered, author: .Operator),
            ChatMessage(id: 808366, date: formatter.dateFromString("2015-08-14T13:11:13.39Z")!, text: "ЁЖ\nПротопопов пишет, что самки выбирают себе самцов для спаривания в природе. Если хоть немного поизучать поведение групповых животных, то станет очевидно, что это утверждение не является истиной. Например, в стае волков \"право\" на спаривание имеется только у альфа-самца и у альфа-самки. остальные особи в размножении не учавствуют. Иначе КАЖДАЯ самка должна бы быть либо беременна либо иметь щенков. В таком положении стая нежизнеспособна. Выбор самкой самца не более, чим миф. Примативность - явно выдуманный термин, являющийся карикатурой на психологическую реактивность мозга.", requestStatus: .Requested, author: .Client)

        ]
        let changeRequests = [
            ATOrderInfo.changeRequestFromData([
                "Id": "b2490a20-d2fb-4044-8043-e5704b20fb30",
                "PaySystemTag": "BankCardRub",
                "PaymentMethod": "CreditCard",
                "PaymentAccountId": NSNull(),
                "IsDelayedPaySystem": false,
                "PersonalAccountChargeOffAvailable": false,
                "IsLatest": false,
                "RapidaTimeLimitUTC": "2015-10-06T20:00:00Z",
                "TimeLimitLocalTime": "2015-10-06T23:00:00+03:00",
                "CreatedDate": "2015-10-06T13:08:57.57+03:00",
                "PaymentDate": "2015-10-06T00:00",
                "Status": "WaitingForPayment",
                "TotalAmountCeiled": 1054.0,
                "TotalAmountCeiledEur": 14.0,
                "Currency": "RUB",
                "CardholderName": NSNull(),
                "PaymentId": NSNull(),
                "PayMarkup": 0.0,
                "TicketNumber": NSNull(),
                "Trips": [],
                "InvoiceNumber": "227949924",
                "AlertCode": NSNull(),
                "IsAlertClosed": false,
                "TotalSurchargeWoPaySystem": 1030.0,
                "PassengerName": "Andrew Weatherall"
            ]), ATOrderInfo.changeRequestFromData([
                "Id": "01484586-13b0-437e-81b5-9327f3143a0f",
                "PaySystemTag": "BankCardRub",
                "PaymentMethod": "CreditCard",
                "PaymentAccountId": NSNull(),
                "IsDelayedPaySystem": false,
                "PersonalAccountChargeOffAvailable": false,
                "IsLatest": true,
                "RapidaTimeLimitUTC": "2015-10-09T20:00:00Z",
                "TimeLimitLocalTime": "2015-10-09T23:00:00+03:00",
                "CreatedDate": "2015-10-06T13:06:42.61+03:00",
                "PaymentDate": "2015-10-06T13:07",
                "Status": "PaymentCaptured",
                "TotalAmountCeiled": 7.0,
                "TotalAmountCeiledEur": 1.0,
                "Currency": "RUB",
                "CardholderName": NSNull(),
                "PaymentId": NSNull(),
                "PayMarkup": 0.0,
                "TicketNumber": "1234567890",
                "Trips": [],
                "InvoiceNumber": NSNull(),
                "AlertCode": NSNull(),
                "IsAlertClosed": false,
                "TotalSurchargeWoPaySystem": 250.0,
                "PassengerName": "Thomas Jefferson"
            ])
        ]
        let data: [String: AnyObject] = [
            "OrderNum": "821658955",
            "OrderId": "99ceeb96-f92a-472b-b0dd-678a66ab0e44",
            "RequestID": "4d0607a3-8b34-4f01-af36-fc28517171bd",
            "DateCreated": ["Date": "2015-08-14T13:09:17.39Z"],
            "OperatorOwnerName": "Vasiliy",
            "RequestType": "CHANGE",
            "Reason": "ILLNESS",
//            "Status": "CANCELED"
//            "Status": "CONFIRMED"
            "Status": "AWAITING_CONFIRM"
//            "Status": "REQUESTED"
//            "Status": "ANSWERED"
//            "Status": "FINISHED"
        ]
        do {
            let request = try ExchangeAndRefundRequest(data: data, messages: messages, changeRequests: changeRequests)

            let controller = ExchangeAndRefundViewController(request: request)
            controller.cancelRequestButton.addTarget(self, action: "cancelRequestButtonPressed:", forControlEvents: .TouchUpInside)
            controller.refreshButton.addTarget(self, action: "refreshButtonPressed:", forControlEvents: .TouchUpInside)

            if isIpad {
                presentSideView(controller)
            } else {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } catch let error where error is ExchangeAndRefundRequest.ParseError {
            UIAlertView (title: "Error!", message: "Unable to parse Exchange & Refund request: \(error)", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
        } catch {
            UIAlertView (title: "Error!", message: "Unable to parse Exchange & Refund request!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
        }
    }

    // MARK: Buttons handlers
    @objc private func cancelRequestButtonPressed(button: UIButton) {
        print("Cancel button pressed")
    }
    @objc private func refreshButtonPressed(button: UIButton) {
        print("Refresh button pressed")
    }
    @objc private func closeButtonPressed(button: UIBarButtonItem) {
        print("Close button pressed")

        navigationItem.rightBarButtonItem = nil
        sideViewController?.willMoveToParentViewController(nil)
        sideViewController?.view.removeFromSuperview()
        sideViewController?.removeFromParentViewController()
        sideViewController = nil
    }

    private func presentSideView(controller: UIViewController) {
        addChildViewController(controller)
        controller.view.frame = CGRect(origin: CGPoint(x: view.bounds.size.width, y: 64), size: CGSize(width: 320, height: view.bounds.size.height))
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(controller.view)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[child]|", options: [], metrics: nil, views: ["child": controller.view]))
        controller.view.constrainWidth(320)
        let leadingConstraint = NSLayoutConstraint(item: controller.view, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -320)
        view.addConstraint(leadingConstraint)

        controller.didMoveToParentViewController(self)
        sideViewController = controller

        UIView.animateWithDuration(0.3) {
            leadingConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }

        let closeButton = UIBarButtonItem(title: NSLocalizedString("LocClose", comment:""), style: .Bordered, target: self, action: "closeButtonPressed:")
        navigationItem.rightBarButtonItem = closeButton
    }

}

private class SideViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override func viewDidLoad() {
        view.backgroundColor = UIColor.magentaColor()
    }

    func configureWithChildViewController(controller: UIViewController) {

        addChildViewController(controller)
        controller.view.frame = CGRect(origin: CGPointZero, size: CGSize(width: 320, height: 568))
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(controller.view)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[child]|", options: [], metrics: nil, views: ["child": controller.view]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[child]|", options: [], metrics: nil, views: ["child": controller.view]))

        controller.didMoveToParentViewController(self)
    }
}

