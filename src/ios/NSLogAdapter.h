//
//  NSLogAdapter.h
//  EGCreditCardPlugin
//
//  Created by Nate Petersen on 4/16/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGLoggingDelegate.h"

/**
 * Simple logging delegate that just outputs to NSLog.
 */
@interface NSLogAdapter : NSObject <EGLoggingDelegate>

- (instancetype)initWithLogThreshold:(EGLogLevel)threshold;

@end
