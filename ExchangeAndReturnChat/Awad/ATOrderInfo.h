//
//  ATOrderInfo.h
//  Awad2
//
//  Created by tikhop on 01/02/2013.
//  Copyright (c) 2013 anywayanyday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@class ATOrderInfoTicketPassenger;
@class ATOrderInfoTrip;
@class ATOrderChangeRequest;
@class Phone;
@class AwadStatus;

@interface ATOrderInfo : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *fareId;

@property (nonatomic, strong) NSString *createdDate; //"2012-08-30T17:54:07.133+04:00"
@property (nonatomic, assign) OrderStatusCode status;
@property (nonatomic, strong) AwadStatus *awadStatus;
@property (nonatomic, strong) NSString *invoiceNumber;
@property (nonatomic, assign) BOOL needsMiddleName;
@property (nonatomic, strong) NSArray *attentions;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *priceEur;
@property (nonatomic, strong) NSString *currency;

@property (nonatomic, strong) NSString *paymentMethod;
@property (nonatomic, strong) NSString *paySystem;
@property (nonatomic, strong) NSString *timeLimitUTC; //2013-03-01T19:59:00Z
@property (nonatomic, strong, readonly) NSDate *timeLimitDate;
@property (nonatomic, strong) NSString *paymentAccountId;

@property (nonatomic, strong) NSString *cancelReason;
@property (nonatomic, strong) NSString *cancelDate; //"2013-01-01T22:10:07.53+04:00"

@property (nonatomic, strong) NSArray *sameTickets; //[ATOrderInfoTicket, ATOrderInfoTicket];
@property (nonatomic, strong) NSArray *differentTickets; //[ATOrderInfoTicket, ATOrderInfoTicket];

@property (nonatomic, strong) ATOrderInfoTrip *defaultTrip;
@property (nonatomic, strong) NSArray *stopsForOrder;

@property (nonatomic, strong) NSArray *discounts;

@property (nonatomic, strong) NSArray *payProcesses;

@property (nonatomic, strong) NSNumber *timeToTravel;
@property (nonatomic, strong) NSNumber *travelDuration;

// Дата полседнего обновления данных.
@property (nonatomic, strong) NSDate *savedDate;

// Для выделения случая когда ManualModeTag равен SUCodeShare или CodeShare (см. MOBI-3610)
@property (nonatomic, strong) NSString *manualModeTag;

@property (nonatomic, strong) Phone *phone;

- (ATOrderInfoTrip *)orderInfoTripByTicketId:(NSString *)ticketId;

+ (ATOrderChangeRequest *__nonnull)changeRequestFromData:(NSDictionary <NSString *, NSObject *>*)data;

@end

@interface Phone : NSObject <NSCopying>
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *numericCode;
@property (nonatomic, strong) NSString *countryCode;
+ (Phone *)phoneFromData:(NSDictionary *)data;
- (NSString *)string;
@end

@interface ATOrderInfoTicket : NSObject

@property (nonatomic, strong) NSString *ticketId;
@property (nonatomic, strong) NSString *ticketNumber;
@property (nonatomic, strong) ATOrderInfoTicketPassenger *passenger;

@property (nonatomic, strong) NSArray *changeRequests; //[ATOrderChangeRequest, ATOrderChangeRequest]
@property (nonatomic, strong) NSArray *returnRequests; //[ATOrderReturnRequest, ATOrderReturnRequest];
@end

@interface ATOrderInfoTicketPassenger : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *gender; //F M
@property (nonatomic, strong) NSString *nationality; //RU
@property (nonatomic, strong) NSString *passport;
@property (nonatomic, strong) NSString *birthDate; //"1984-07-19"
@property (nonatomic, strong) NSString *documentExpiration; //"2020-09-01"
@property (nonatomic, strong) NSString *documentType; // RussianInternalPassport
@property (nonatomic, strong) NSString *rawFirstName; // первоисходное имя, не измененное GDS-ом
@property (nonatomic, strong) NSString *rawLastName;  // первоисходная фамилия, не измененная GDS-ом

@end

@interface ATOrderInfoTrip : NSObject
@property (nonatomic, strong) NSArray *directions; //[ATOrderInfoTripDirection, ATOrderInfoTripDirection];
@end

@interface ATOrderInfoTripDirection : NSObject
@property (nonatomic, strong) NSString *journalTime;
@property (nonatomic, strong) NSString *flightDuration;
@property (nonatomic, strong) NSArray *legs;
@property (nonatomic, strong) NSArray *flightConnections; // [FlightConnection, FlightConnection];
@property (nonatomic, strong) NSArray *stops;
@end

@interface ATOrderChangeRequest : NSObject
@property (nonatomic, strong) NSString *changeId;
@property (nonatomic, strong) NSString *ticketNumber;
@property (nonatomic, strong) NSString *createdDate; //"2013-02-01T14:26:25.94+04:00"
@property (nonatomic, strong) NSString *paymentDate; //2013-07-31T20:01
@property (nonatomic, strong) NSString *rapidaTimeLimitUTC; //2014-06-25T21:00:00Z
@property (nonatomic, strong) NSString *alertCode;
@property (nonatomic, getter=isAlertClosed) BOOL alertClosed;
@property (nonatomic, assign) OrderStatusCode status;
@property (nonatomic, assign) double totalAmountCeiled;
@property (nonatomic, assign) double totalAmountCeiledEur;
@property (nonatomic, assign) double payMarkup;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *paymentMethod;
@property (nonatomic, strong) NSString *paymentTag;
@property (nonatomic, strong) NSString *paymentAccountId;
@property (nonatomic, strong) ATOrderInfoTrip *trip;
@property (nonatomic, assign) BOOL isLatest;
@end

@interface ATOrderReturnRequest : NSObject
@property (nonatomic, strong) NSString *returnId;
@property (nonatomic, strong) NSString *dateCreated; //"2013-02-01T12:50:53.413+04:00"
@property (nonatomic, assign) OrderStatusCode status;
@property (nonatomic, strong) NSString *totalToClientAmount;
@property (nonatomic, strong) NSString *totalTicketAmount;
@end