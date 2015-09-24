//
//  EGCreditCardInfoImpl.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 9/24/15.
//  Copyright © 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGCreditCardInfo.h"

@interface EGCreditCardInfoImpl : NSObject <EGCreditCardInfo>

- (instancetype)initWithTrack1Data:(NSString*)track1Data track2Data:(NSString*)track2Data;

@end
