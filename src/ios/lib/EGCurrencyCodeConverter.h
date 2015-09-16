//
//  EGCurrencyCodeConverter.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 8/25/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGCurrencyCodeConverter : NSObject

+ (NSString*)numericCodeForAlphaCode:(NSString*)alphaCode;

@end
