//
//  EGCardReaderManager.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EGCardTransaction;
@protocol EGFlightInfo;
@protocol EGLoggingDelegate;
@protocol EGTransactionResult;

/**
 * These constants are used in error messages.
 */
extern NSString* const EGCreditCardHandlerErrorDomain;

extern const NSInteger EGCreditCardHandlerTransactionCancelledErrorCode;
extern const NSInteger EGCreditCardHandlerIngenicoSDKErrorCode;
extern const NSInteger EGCreditCardHandlerInvalidOrChipCardErrorCode;

/**
 * A callback that is executed when a transaction is complete.
 * If an error occurs, the error parameter will be non-nil.
 */
typedef void (^EGTransactionCallback)(id<EGTransactionResult> transactionResult, NSError* error);

/**
 * A manager responsible for interacting with the card reader device.
 */
@interface EGCardReaderManager : NSObject

/**
 * This delegate is responsible for providing logging facilities for the card reader.
 */
@property(nonatomic, weak, readonly) id<EGLoggingDelegate> loggingDelegate;

/**
 * Standard initializer. NOTE: like all Objective-C initializers, this can return
 * 'nil' in certain circumstances.
 */
- (instancetype)initWithLoggingDelegate:(id<EGLoggingDelegate>)loggingDelegate;

/**
 * Requests that the card reader perform a swipe transaction.
 * This is an asynchronous operation.
 *
 * @param transaction An EGCardTransaction representing the desired transaction.
 * @param callback A block that will be executed when the transaction completes.
 */
- (void)performSwipeTransaction:(id<EGCardTransaction>)transaction withCallback:(EGTransactionCallback)callback;

/**
 * Requests that the card reader perform an NFC transaction.
 * This is an asynchronous operation.
 *
 * @param transaction An EGCardTransaction representing the desired transaction.
 * @param callback A block that will be executed when the transaction completes.
 */
- (void)performNFCTransaction:(id<EGCardTransaction>)transaction withCallback:(EGTransactionCallback)callback;

/**
 * Requests that the card reader perform an EMV (i.e., chip and PIN) transaction.
 * This is an asynchronous operation.
 *
 * @param transaction An EGCardTransaction representing the desired transaction.
 * @param callback A block that will be executed when the transaction completes.
 */
- (void)performEMVTransaction:(id<EGCardTransaction>)transaction withCallback:(EGTransactionCallback)callback;

/**
 * Cancels the current credit card transaction. If a transaction is in progress, it's callback
 * will be called with an error.
 */
- (void)cancelTransaction;

@end
