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
