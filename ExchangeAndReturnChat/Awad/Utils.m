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

+ (OrderStatusCode)codeOfStatus:(NSString *)inCode {

    if ([inCode isEqual:@"MoneyBlocked"])
        return MoneyBlocked;
    else if ([inCode isEqual:@"Reserved"])
        return Reserved;
    else if ([inCode isEqual:@"Issued"])
        return Issued;
    else if ([inCode isEqual:@"Captured"])
        return Captured;
    else if ([inCode isEqual:@"MoneyUnblocked"])
        return MoneyUnblocked;
    else if ([inCode isEqual:@"ReservationCanceled"])
        return ReservationCanceled;
    else if ([inCode isEqual:@"ChangeDateTime"])
        return ChangeDateTime;
    else if ([inCode isEqual:@"Canceled"])
        return Canceled;
    else if ([inCode isEqual:@"ManualMode"])
        return ManualMode;
    else if ([inCode isEqual:@"AwaitingPayment"])
        return AwaitingPayment;
    else if ([inCode isEqual:@"AwaitingCardVerification"])
        return AwaitingCardVerification;
    else if ([inCode isEqual:@"CardVerified"])
        return CardVerified;
    else if ([inCode isEqual:@"CardNotVerified"])
        return CardNotVerified;
    else if ([inCode isEqual:@"WaitingCustomerConfirm"])
        return WaitingCustomerConfirm;
    else if ([inCode isEqual:@"ReservationRetrived"])
        return ReservationRetrived;
    else if ([inCode isEqual:@"WaitingReturnFrom3DS"])
        return WaitingReturnFrom3DS;
    else if ([inCode isEqual:@"Successful3DsAuth"])
        return Successful3DsAuth;
    else if ([inCode isEqual:@"WaitingBooking"])
        return WaitingBooking;
    else if ([inCode isEqual:@"FraudChecked"])
        return FraudChecked;
    else if ([inCode isEqual:@"CardInfoGot"])
        return CardInfoGot;
    else if ([inCode isEqual:@"PaymentNotRegistered"])
        return PaymentNotRegistered;
    else if ([inCode isEqual:@"PaymentRegistered"])
        return PaymentRegistered;
    else if ([inCode isEqual:@"RequestComplete"])
        return RequestComplete;
    else if ([inCode isEqual:@"RequestCompleteTech"])
        return RequestComplete;
    else if ([inCode isEqual:@"PaymentCaptured"])
        return PaymentCaptured;
    else if ([inCode isEqual:@"Deleted"])
        return Deleted;
    else if ([inCode isEqual:@"InProcess"])
        return InProcess;
    else if ([inCode isEqual:@"WaitingForPayment"])
        return WaitingForPayment;
    else if ([inCode isEqual:@"PaymentComplete"])
        return PaymentComplete;
    else
        return InvalidStatus;

}

//+ (OrderStatusCode)codeOfStatus:(NSString *)inCode
//{
//    NSNumber *val = [self orderStatusesDictionary][inCode];
//    return (val == nil) ? InvalidStatus : (OrderStatusCode)[val intValue];
//}

+ (NSString *)convertedDateString:(NSString *)dateString
                       fromFormat:(NSString *)inputFormat
                         toFormat:(NSString *)outputFormat
                isSourceDateInUTC:(BOOL)isSourceDateInUTC
{
    return [self convertedDateString:dateString fromFormatArray:@[inputFormat] toFormat:outputFormat isSourceDateInUTC:isSourceDateInUTC];
}

+ (NSString *)convertedDateString:(NSString *)dateString
                  fromFormatArray:(NSArray *)inputFormatArray
                         toFormat:(NSString *)outputFormat
                isSourceDateInUTC:(BOOL)isSourceDateInUTC
{
    NSTimeZone *sourceTimezone = isSourceDateInUTC ? [NSTimeZone timeZoneWithAbbreviation:@"UTC"] : [NSTimeZone localTimeZone];
    NSTimeZone *targetTimezone = [NSTimeZone localTimeZone];

    return [self convertedDateString:dateString
                     fromFormatArray:inputFormatArray
                            timezone:sourceTimezone
                            toFormat:outputFormat
                            timezone:targetTimezone];
}

+ (NSString *)convertedDateString:(NSString *)dateString
                  fromFormatArray:(NSArray *)inputFormatArray
                         timezone:(NSTimeZone *)sourceTimezone
                         toFormat:(NSString *)outputFormat
                         timezone:(NSTimeZone *)targetTimezone
{
    static NSDateFormatter *formatter;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        formatter = [NSDateFormatter new];
    });

    formatter.timeZone = sourceTimezone;
    NSDate *date;

    for (NSString *inputFormat in inputFormatArray) {
        formatter.dateFormat = inputFormat;
        date = [formatter dateFromString:dateString];

        if (date != nil)
            break;
    }

    formatter.dateFormat = outputFormat;
//    formatter.locale = [AppDefs locale];
    formatter.timeZone = targetTimezone;

    return [formatter stringFromDate:date];
}

@end
