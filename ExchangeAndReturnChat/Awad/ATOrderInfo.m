//
//  ATOrderInfo.m
//  Awad2
//
//  Created by tikhop on 01/02/2013.
//  Copyright (c) 2013 anywayanyday. All rights reserved.
//

#import "ATOrderInfo.h"
//#import "NSDateFormatter+HHExtensions.h"
//#import "AwadStatus.h"
//#import "NSObject+Awad.h"

#define VALUE_OR_NIL(a) (![[NSNull null] isEqual:a] ? (a) : nil)

@implementation ATOrderInfo

- (ATOrderInfoTrip *)orderInfoTripByTicketId:(NSString *)ticketId
{
	ATOrderInfoTrip *trip;
	ATOrderInfoTicket *ticket;
	
	if(ticketId == nil)
		trip = self.defaultTrip;
	else
	{
		ATOrderChangeRequest *changeRequest;
		
		for (NSInteger i = 0; i<self.differentTickets.count; i++)
		{
			ticket = self.differentTickets[i];
			
			if([ticket.ticketId isEqualToString:ticketId])
			{
				changeRequest = ticket.changeRequests[0];
				trip = changeRequest.trip;
			}
		}
	}
	
	return trip;
}

//- (void)setTimeLimitUTC:(NSString *)timeLimitUTC
//{
//    if (timeLimitUTC != _timeLimitUTC)
//    {
//        _timeLimitUTC = timeLimitUTC;
//
//        NSArray *dateFormatters = @[
//                [NSDateFormatter sharedFormatterWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"],
//                [NSDateFormatter sharedFormatterWithFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"]
//        ];
//
//        for (NSDateFormatter *dateFormatter in dateFormatters)
//        {
//            _timeLimitDate = [dateFormatter dateFromString:timeLimitUTC];
//
//            if (_timeLimitDate != nil) {
//                break;
//            }
//        }
//    }
//}

+ (ATOrderChangeRequest *)changeRequestFromData:(NSDictionary *)data;
{
//    NSArray *trip = [data objectForKey:@"Trips"];

    ATOrderChangeRequest *changeRequest = [ATOrderChangeRequest new];
    changeRequest.createdDate = [data objectForKey:@"CreatedDate"];
    changeRequest.paymentDate = [data objectForKey:@"PaymentDate"];
    changeRequest.rapidaTimeLimitUTC =  VALUE_OR_NIL(data[@"RapidaTimeLimitUTC"]);
    changeRequest.alertCode =  VALUE_OR_NIL(data[@"AlertCode"]);
    changeRequest.alertClosed = [data[@"IsAlertClosed"] boolValue];
    changeRequest.status = [Utils codeOfStatus:[data objectForKey:@"Status"]];
    changeRequest.ticketNumber = [data objectForKey:@"TicketNumber"];
    changeRequest.changeId = [data objectForKey:@"Id"];
//    changeRequest.trip = trip.count ? [self tripFromData:trip] : _orderInfo.defaultTrip;
    changeRequest.isLatest = [[data objectForKey:@"IsLatest"] boolValue];
    changeRequest.currency = data[@"Currency"];
    changeRequest.paymentMethod = data[@"PaymentMethod"];
    changeRequest.totalAmountCeiled = [data[@"TotalAmountCeiled"] doubleValue];
    changeRequest.totalAmountCeiledEur = [data[@"TotalAmountCeiledEur"] doubleValue];
    changeRequest.payMarkup = [data[@"PayMarkup"] doubleValue];
    changeRequest.paymentTag = data[@"PaySystemTag"];
    changeRequest.paymentAccountId = data[@"PaymentAccountId"];
    return [self hasCorrectChangeStatus:changeRequest] ? changeRequest : nil;
}

+ (BOOL)hasCorrectChangeStatus:(ATOrderChangeRequest *)changeRequest
{
    OrderStatusCode status = changeRequest.status;
#if EXCHANGE_RESULTS
    if (status == PaymentCaptured || status == WaitingForPayment || status == PaymentComplete)
        return YES;
    else
        return (status == InProcess && [changeRequest.alertCode isEqualToString:@"ExchangeCancelExpiredPay"] && ![changeRequest isAlertClosed]);

#endif
    return (status == PaymentCaptured);
}

@end

@implementation Phone

+ (Phone *)phoneFromData:(NSDictionary *)data
{
    Phone *phone = [Phone new];
    phone.countryCode = data[@"CountryCode"];
    phone.numericCode = data[@"NumericCode"];
    phone.number = data[@"Number"];
    return phone;
}

- (id)copyWithZone:(NSZone *)zone
{
    Phone *p = [Phone new];
    p.countryCode = self.countryCode;
    p.numericCode = self.numericCode;
    p.number = self.number;
    return p;
}

//- (BOOL)isEqual:(Phone *)object
//{
//    if(self == object)
//        return YES;
//    
//    if([object isKindOfClass:[self class]])
//    {
//        return [self hasEqualProperties:object properties:@[@"countryCode", @"numericCode", @"number"]];
//    }
//    
//    return NO;
//}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n%@",[super description], [self string]];
}

- (NSString *)string
{
    return [NSString stringWithFormat:@"+%@ %@", self.numericCode, self.number];
}

@end

@implementation ATOrderInfoTicket
@end

@implementation ATOrderInfoTicketPassenger
@end

@implementation ATOrderInfoTrip
@end

@implementation ATOrderChangeRequest
@end

@implementation ATOrderReturnRequest
@end

@implementation ATOrderInfoTripDirection

@end