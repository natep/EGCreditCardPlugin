//
//  EGTransactionResult.h
//  EGPaymentService
//
//  Created by Nate Petersen on 5/1/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#ifndef EGPaymentService_EGTransactionResult_h
#define EGPaymentService_EGTransactionResult_h

/**
 * The type of transaction being processed.
 */
typedef enum {
	EGCardTransactionTypePurchase,
	EGCardTransactionTypeRefund
} EGCardTransactionType;

/**
 * Represents the results of a successful card transaction.
 */
@protocol EGTransactionResult <NSObject>

@property (nonatomic, copy, readonly) NSArray* items;	//< EGTransactionItem
@property (nonatomic, readonly) EGCardTransactionType type;
@property (nonatomic, copy, readonly) NSString* seatNumber;
@property (nonatomic, copy, readonly) NSString* fareClass;
@property (nonatomic, copy, readonly) NSString* frequentFlyerStatus;
@property (nonatomic, copy, readonly) NSString* currencyCode;
@property (nonatomic, copy, readonly) NSString* uniqueTransactionId;
@property (nonatomic, copy, readonly) NSString* cardTrackData;
@property (nonatomic, copy, readonly) NSDecimalNumber* amount;

@end

#endif
