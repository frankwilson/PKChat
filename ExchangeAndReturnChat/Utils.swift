//
//  Utils.swift
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 05/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

import Foundation

@inline(__always) func stringOrNil(object: AnyObject?) -> String? {
    if let stringValue = object as? String {
        return stringValue
    }
    return nil
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
        dispatch_get_main_queue(),
        closure
    )
}
