//
//  Utils.m
//  ExchangeAndReturnChat
//
//  Created by Pavel Kazantsev on 06/10/15.
//  Copyright © 2015 Anywayanyday. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSDictionary *)orderStatusesDictionary
{
    static NSDictionary *dict = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        //Для добавления новых не забыть исправить перечесление в хидере.
        dict = @{
                 @"MoneyBlocked":[NSNumber numberWithInt:MoneyBlocked],
                 @"Reserved":[NSNumber numberWithInt:Reserved],
                 @"Issued":[NSNumber numberWithInt:Issued],
                 @"Captured":[NSNumber numberWithInt:Captured],
                 @"MoneyUnblocked":[NSNumber numberWithInt:MoneyUnblocked],
                 @"ReservationCanceled":[NSNumber numberWithInt:ReservationCanceled],
                 @"ChangeDateTime":[NSNumber numberWithInt:ChangeDateTime],
                 @"Canceled":[NSNumber numberWithInt:Canceled],
                 @"ManualMode":[NSNumber numberWithInt:ManualMode],
                 @"AwaitingPayment":[NSNumber numberWithInt:AwaitingPayment],
                 @"AwaitingCardVerification":[NSNumber numberWithInt:AwaitingCardVerification],
                 @"CardVerified":[NSNumber numberWithInt:CardVerified],
                 @"CardNotVerified":[NSNumber numberWithInt:CardNotVerified],
                 @"WaitingCustomerConfirm":[NSNumber numberWithInt:WaitingCustomerConfirm],
                 @"ReservationRetrived":[NSNumber numberWithInt:ReservationRetrived],
                 @"WaitingReturnFrom3DS":[NSNumber numberWithInt:WaitingReturnFrom3DS],
                 @"Successful3DsAuth":[NSNumber numberWithInt:Successful3DsAuth],
                 @"WaitingBooking":[NSNumber numberWithInt:WaitingBooking],
                 @"FraudChecked":[NSNumber numberWithInt:FraudChecked],
                 @"CardInfoGot":[NSNumber numberWithInt:CardInfoGot],
                 @"PaymentNotRegistered":[NSNumber numberWithInt:PaymentNotRegistered],
                 @"PaymentRegistered":[NSNumber numberWithInt:PaymentRegistered],
                 @"RequestComplete":[NSNumber numberWithInt:RequestComplete],
                 @"RequestCompleteTech":[NSNumber numberWithInt:RequestComplete],
                 @"PaymentCaptured":[NSNumber numberWithInt:PaymentCaptured],
                 @"Deleted":[NSNumber numberWithInt:Deleted],
                 @"InProcess":[NSNumber numberWithInt:InProcess],
                 @"WaitingForPayment":[NSNumber numberWithInt:WaitingForPayment],
                 @"PaymentComplete":[NSNumber numberWithInt:PaymentComplete],
                 };
    });

    return dict;
}

+ (OrderStatusCode)codeOfStatus:(NSString *)inCode
{
    NSNumber *val = [self orderStatusesDictionary][inCode];
    return (val == nil) ? InvalidStatus : [val intValue];
}

@end
