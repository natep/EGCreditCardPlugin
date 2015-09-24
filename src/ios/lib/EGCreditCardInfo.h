//
//  EGCreditCardInfo.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 9/24/15.
//  Copyright © 2015 eGate Solutions. All rights reserved.
//

#ifndef EGCreditCardInfo_h
#define EGCreditCardInfo_h

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
	EGVisaCreditCardType,
	EGMastercardCreditCardType,
	EGAmexCreditCardType,
	EGDiscoverCreditCardType,
	EGDinersCreditCardType,
	EGJCBCreditCardType,
	EGCarteBlancheCreditCardType,
	EGDankortCreditCardType,
	EGUnknownCreditCardType
} EGCreditCardType;

@protocol EGCreditCardInfo <NSObject>

@property(nonatomic,strong,readonly) NSString* cardholderName;
@property(nonatomic,strong,readonly) NSString* expirationDate;
@property(nonatomic,strong,readonly) NSString* cardNumber;
@property(nonatomic,readonly) EGCreditCardType cardType;

@end

#endif /* EGCreditCardInfo_h */
