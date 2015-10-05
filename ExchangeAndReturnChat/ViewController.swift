//
//  ViewController.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 29/09/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        UINavigationBar.appearance().barTintColor = UIColor.iphoneMainNavbarColor()
    }

    @IBAction func didTapButton(button: UIButton) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        let messages = [
            ChatMessage(date: formatter.dateFromString("2015-08-14T13:09:17.39Z")!, text: "Здравствуйте!\nПодскажите, пожалуйста, а у вас есть ольховые плинтуса?", requestStatus: .Requested, author: .Client),
            ChatMessage(date: formatter.dateFromString("2015-08-14T13:10:57.67Z")!, text: "Нет, у нас только дубовые!", requestStatus: .Answered, author: .Operator),
            ChatMessage(date: formatter.dateFromString("2015-08-14T13:11:43.03Z")!, text: "Хм, но как же так... А у меня есть какой-нибудь выбор?", imageUrl: NSURL(string: "https://www.anywayanyday.com/hotelimages_new/c8/ae/d6/419a79/65D742_72_z.jpg"), requestStatus: .Requested, author: .Client),
            ChatMessage(date: formatter.dateFromString("2015-08-14T13:13:42.32Z")!, text: "Конечно, у вас есть выбор! Взять дубовые, или пойти и выкоречевать ольху. Ведь все дубы пошли на плинтуса, а ольха нет!", requestStatus: .Answered, author: .Operator),
            ChatMessage(date: formatter.dateFromString("2015-08-14T13:18:33.39Z")!, text: "Ну и ладно. Оставайтесь при своих.", requestStatus: .Cancelled, author: .Client)
        ]
        let data: [String: AnyObject] = [
            "OrderNum": "821658955",
            "OrderId": "99ceeb96-f92a-472b-b0dd-678a66ab0e44",
            "RequestID": "4d0607a3-8b34-4f01-af36-fc28517171bd",
            "DateCreated": ["Date": "2015-08-14T13:09:17.39Z"],
            "OperatorOwnerName": "Vasiliy",
            "RequestType": "RETURN",
            "Reason": "ILLNESS",
            "Status": "CANCELED"
//            "Status": "CONFIRMED"
//            "Status": "AWAITING_CONFIRM"
//            "Status": "REQUESTED"
//            "Status": "ANSWERED"
//            "Status": "FINISHED"
        ]
        do {
            let request = try ExchangeAndRefundRequest(data: data, messages: messages)

            let controller = ExchangeAndRefundViewController(request: request)

            let navController = UINavigationController(rootViewController: controller)

            self.presentViewController(navController, animated: true, completion: nil)
        } catch let error where error is ExchangeAndRefundRequest.ParseError {
            UIAlertView (title: "Error!", message: "Unable to parse Exchange & Refund request: \(error)", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
        } catch {
            UIAlertView (title: "Error!", message: "Unable to parse Exchange & Refund request!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
        }

    }

}

