//
//  Utils.h
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 06/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(int8_t, OrderStatusCode) {
    InvalidStatus = 0,
    MoneyBlocked,
    Reserved,
    Issued,
    Captured,
    MoneyUnblocked,
    ReservationCanceled,
    ChangeDateTime,
    Canceled,
    ManualMode,
    AwaitingPayment,
    AwaitingCardVerification,
    CardVerified,
    CardNotVerified,
    WaitingCustomerConfirm,
    ReservationRetrived,
    WaitingReturnFrom3DS,
    Successful3DsAuth,
    WaitingBooking,
    FraudChecked,
    CardInfoGot,
    PaymentNotRegistered,
    PaymentRegistered,
    RequestComplete,
    // ChangeRequests
    PaymentCaptured,
    Deleted,
    InProcess,
    WaitingForPayment,
    PaymentComplete
};

@interface Utils : NSObject

+ (NSDictionary *)orderStatusesDictionary;
+ (OrderStatusCode)codeOfStatus:(NSString*)inCode;

+ (NSString *)convertedDateString:(NSString *)dateString
                       fromFormat:(NSString *)inputFormat
                         toFormat:(NSString *)outputFormat
                isSourceDateInUTC:(BOOL)isSourceDateInUTC;

+ (NSString *)convertedDateString:(NSString *)dateString
                  fromFormatArray:(NSArray *)inputFormatArray
                         toFormat:(NSString *)outputFormat
                isSourceDateInUTC:(BOOL)isSourceDateInUTC;

@end
