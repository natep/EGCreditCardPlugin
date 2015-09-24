//
//  EGCreditCardInfoImpl.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 9/24/15.
//  Copyright © 2015 eGate Solutions. All rights reserved.
//

#import "EGCreditCardInfoImpl.h"

@implementation EGCreditCardInfoImpl

@synthesize expirationDate = _expirationDate;
@synthesize cardholderName = _cardholderName;
@synthesize cardNumber = _cardNumber;
@synthesize cardType = _cardType;

- (instancetype)initWithTrack1Data:(NSString*)track1Data track2Data:(NSString*)track2Data
{
	self = [super init];
	
	if (self) {
		[self parseTrack1Data:track1Data];
		[self parseTrack2Data:track2Data];
	}
	
	return self;
}

- (void)parseTrack1Data:(NSString*)track1
{
	if (track1.length > 0) {
		NSArray* comps = [track1 componentsSeparatedByString:@"^"];
		
		if (comps.count == 3) {
			_cardholderName = comps[1];
		}
	}
}

- (void)parseTrack2Data:(NSString*)track2
{
	if (track2.length > 0) {
		NSArray* comps = [track2 componentsSeparatedByString:@"="];
		
		if (comps.count == 2) {
			NSString* comp = comps[0];
			_cardNumber = [comp substringFromIndex:1];
			
			comp = comps[1];
			_expirationDate = [comp substringToIndex:4];
		} else if (comps.count < 2) {
			comps = [track2 componentsSeparatedByString:@"D"];
			
			if (comps.count == 2) {
				NSString* comp = comps[0];
				_cardNumber = comp;
				
				comp = comps[1];
				_expirationDate = [comp substringToIndex:4];
			}
		}
		
		if (self.cardNumber.length > 0) {
			_cardType = [self.class cardTypeForNumber:self.cardNumber];
		}
	}
}

+ (EGCreditCardType)cardTypeForNumber:(NSString*)cardNumber
{
	NSUInteger len = cardNumber.length;
	
	if ((len == 13 || len == 16 || len == 19) &&
		[cardNumber hasPrefix:@"4"])
	{
		return EGVisaCreditCardType;
	}
	
	if ((len == 16 || len == 19) &&
		([cardNumber hasPrefix:@"51"] ||
		 [cardNumber hasPrefix:@"52"] ||
		 [cardNumber hasPrefix:@"53"] ||
		 [cardNumber hasPrefix:@"54"] ||
		 [cardNumber hasPrefix:@"55"]))
	{
		return EGMastercardCreditCardType;
	}
	
	if (len == 15 && ([cardNumber hasPrefix:@"34"] || [cardNumber hasPrefix:@"37"])) {
		return EGAmexCreditCardType;
	}
	
	if (len == 16) {
		NSUInteger prefix = [[cardNumber substringToIndex:6] integerValue];
		
		if ((prefix >= 601100 && prefix <= 601109) ||
			(prefix >= 601120 && prefix <= 601149) ||
			(prefix == 601174) ||
			(prefix >= 601177 && prefix <= 601179) ||
			(prefix >= 601186 && prefix <= 601199) ||
			(prefix >= 622126 && prefix <= 622925) ||
			(prefix >= 644000 && prefix <= 649999) ||
			(prefix >= 650000 && prefix <= 659999))
		{
			return EGDiscoverCreditCardType;
		}
	}
	
	if ([cardNumber hasPrefix:@"300"] ||
		[cardNumber hasPrefix:@"301"] ||
		[cardNumber hasPrefix:@"302"] ||
		[cardNumber hasPrefix:@"303"] ||
		[cardNumber hasPrefix:@"304"] ||
		[cardNumber hasPrefix:@"305"] ||
		[cardNumber hasPrefix:@"36"])
	{
		return EGDinersCreditCardType;
	}
	
	if (len == 16) {
		NSUInteger prefix = [[cardNumber substringToIndex:6] integerValue];
		
		if (prefix >= 352800 && prefix <= 358999) {
			return EGJCBCreditCardType;
		}
	}
	
	if (len == 14 && [cardNumber hasPrefix:@"389"]) {
		return EGCarteBlancheCreditCardType;
	}
	
	if (len == 16 && [cardNumber hasPrefix:@"5019"]) {
		return EGDankortCreditCardType;
	}
	
	return EGUnknownCreditCardType;
}

@end
