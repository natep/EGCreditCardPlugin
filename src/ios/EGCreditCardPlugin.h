//
//  EGCreditCardPlugin.h
//  EGCreditCardPlugin
//
//  Created by Nate Petersen on 9/10/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

@interface EGCreditCardPlugin : CDVPlugin

- (void)processCreditCard:(CDVInvokedUrlCommand*)command;

@end
